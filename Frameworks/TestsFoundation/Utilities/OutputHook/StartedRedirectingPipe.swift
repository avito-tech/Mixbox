import MixboxFoundation

final class StartedRedirectingPipe {
    private let redirectedFileDescriptor: Int32
    private let readQueue = DispatchQueue(label: "RedirectingPipe.readSyncQueue")
    private let backgroundQueue = DispatchQueue(label: "RedirectingPipe.backgroundQueue")
    private let posixFunctions = PosixFunctions()
    private var duplicatedRedirectedFileDescriptor: Int32
    private var pipeReadEndFileDescriptor: Int32
    private var data = Data()
    
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
        
        backgroundQueue.async { [weak self] in
            self?.read()
        }
    }
    
    // MARK: - Functions
    
    var writtenData: Data {
        waitForData()
        
        return data
    }
    
    func stop() throws {
        waitForData()
        
        try? posixFunctions.close(fileDescriptor: pipeReadEndFileDescriptor)
        
        backgroundQueue.sync {}
    }
    
    // MARK: - Private
    
    private func read() {
        // Read all of the data from the output pipe.
        let bufferLength = 4096
        var buffer = [UInt8](repeating: 0, count: bufferLength + 1)
        
        while true {
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
                    break
                }
            } catch let e as PosixFunctionError {
                if e.errno == EINTR {
                    continue
                } else {
                    break
                }
            } catch {
                break
            }
        }
        
        do {
            try rollback()
        } catch let e {
            // TODO: handle somehow
        }
    }
    
    // VERY stupid solution for waiting data (uses sleep)
    private func waitForData() {
        var rfds = fd_set(
            fds_bits: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        )
        var tv = timeval(tv_sec: 0, tv_usec: 500)
        rfds.fds_bits.0 = 1
        
        let result = select(pipeReadEndFileDescriptor, &rfds, nil, nil, &tv)
        let hasData = result > 0
        
        if hasData {
            sleep(1)
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
    
    private func rollback() throws {
        try posixFunctions.dup2(
            oldFileDescriptor: duplicatedRedirectedFileDescriptor,
            newFileDescriptor: redirectedFileDescriptor
        )
        
        try posixFunctions.close(fileDescriptor: duplicatedRedirectedFileDescriptor)
    }
}
