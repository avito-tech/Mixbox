import MixboxFoundation

final class StartedRedirectingPipe {
    private let redirectedFileDescriptor: Int32
    private let dataPollingQueue = DispatchQueue(label: "StartedRedirectingPipe.dataPollingQueue")
    private let dataGrabbingQueue = DispatchQueue(label: "StartedRedirectingPipe.dataGrabbingQueue")
    private let posixFunctions = PosixFunctions()
    private var duplicatedRedirectedFileDescriptor: Int32
    private var pipeReadEndFileDescriptor: Int32
    private var data = Data()
    private var suspended = true
    
    init(redirectedFileDescriptor: Int32) throws {
        let (readEnd, writeEnd) = try posixFunctions.openPipe()
        
        self.redirectedFileDescriptor = redirectedFileDescriptor
        self.data = Data()
        self.pipeReadEndFileDescriptor = readEnd
        self.duplicatedRedirectedFileDescriptor = try posixFunctions.dup(
            fileDescriptor: redirectedFileDescriptor
        )
        
        try redirect(
            from: redirectedFileDescriptor,
            to: writeEnd
        )
        
        // To not supsend thread when reading from file descriptor that has no data to read,
        // read() will return EAGAIN instead.
        let flags = fcntl(readEnd, F_GETFL, 0)
        _ = fcntl(readEnd, F_SETFL, flags | O_NONBLOCK)
    }
    
    // MARK: - Functions
    
    var writtenData: Data {
        if !suspended {
            grabAllData()
        }
        
        return data
    }
    
    func resume() {
        dataPollingQueue.sync {}
        
        suspended = false
        dataPollingQueue.async { [weak self] in
            self?.pollForData()
        }
        
        grabAllData()
        data = Data()
    }
    
    func suspend() {
        grabAllData()
        
        suspended = true
    }
    
    // MARK: - Private
    
    private func grabAllData() {
        dataGrabbingQueue.sync {
            grabAllDataWhileSyncronized()
        }
    }
    
    private func grabAllDataWhileSyncronized() {
        if !suspended {
            var hasData = true
            let bufferLength = 4096
            var buffer = [UInt8](repeating: 0, count: bufferLength + 1)
            
            // Read all of the data from the output pipe.
            while hasData && !suspended {
                do {
                    let readResult = try posixFunctions.read(
                        fileDescriptor: pipeReadEndFileDescriptor,
                        buffer: &buffer,
                        count: bufferLength
                    )
                    
                    if readResult > 0 {
                        let data = buffer[0..<readResult]
                        handleData(uint8data: Array(data))
                    } else {
                        hasData = false
                    }
                } catch let e as PosixFunctionError {
                    switch e.errno {
                    case EINTR:
                        // I just found on the internet that we should continue reading in this case
                        continue
                    case EAGAIN:
                        // There is no data to read
                        hasData = false
                    default:
                        // Some error occured
                        hasData = false
                    }
                } catch {
                    // Posix function finished successfully, but other error occured
                    hasData = false
                }
            }
        }
    }
    
    private func pollForData() {
        while !suspended {
            let events = Int16(POLLOUT | POLLWRBAND)
            var pollfds = [pollfd(fd: pipeReadEndFileDescriptor, events: events, revents: 0)]
            let timeoutInMilliseconds: Int32 = 1000
            
            let result = poll(&pollfds, nfds_t(pollfds.count), timeoutInMilliseconds)
            
            if result > 0 && (pollfds[0].revents & events > 0) {
                grabAllData()
            }
        }
    }
    
    private func redirect(from: Int32, to: Int32) throws {
        // I have no idea why dup2() that takes oldfd then newfd works when
        // I pass newly created fd to oldfd and existing fd to newfd.
        // It just works this way and not other way round.
        try posixFunctions.dup2(
            oldFileDescriptor: to,
            newFileDescriptor: from
        )
        try posixFunctions.close(
            fileDescriptor: to
        )
    }
    
    private func handleData(uint8data: [UInt8]) {
        data.append(UnsafePointer<UInt8>(uint8data), count: uint8data.count)
    }
    
    // TODO: Implement reverting the hook properly and change interfaces of related classes.
    // The code below is causing SIGPIPE when something was printed in a background thread.
    // Maybe it is not possible. In that case we should add documentation with recommendation to
    // not use hooks in the process or made a process started by other process, which will get all logs properly.
    //
    // Despite it is unstable, we use this method in tests to remove side effects of one tests to others and it
    // doesn't crash inside LogicTests (at the moment) and allows CI to parse xcodebuild's output properly.
    internal func uninstallHook() throws {
        suspended = true
        dataGrabbingQueue.sync {}
        dataPollingQueue.sync {}
        
        signal(SIGPIPE, SIG_IGN) // doesn't help if lldb is attached
        
        try posixFunctions.dup2(
            oldFileDescriptor: duplicatedRedirectedFileDescriptor,
            newFileDescriptor: redirectedFileDescriptor
        )

        try posixFunctions.close(fileDescriptor: duplicatedRedirectedFileDescriptor)
        try posixFunctions.close(fileDescriptor: pipeReadEndFileDescriptor)
    }
}
