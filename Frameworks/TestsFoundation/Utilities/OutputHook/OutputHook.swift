//
// Note: OutputHook is not reliable. It needs sleeps for processing inputs in other threads.
// You can use it to get some output while test is running (for tens of seconds), it would be "okay".
// It wouldn't be okay if you try to get output in a short time interval (milliseconds/few seconds).
//
public  final class OutputHook {
    private let stdoutPipe = RedirectingPipe(redirectedFileDescriptor: fileno(Foundation.stdout))
    private let stderrPipe = RedirectingPipe(redirectedFileDescriptor: fileno(Foundation.stderr))
    
    public init() {
    }
    
    public var stdout: String {
        return String(data: stdoutPipe.writtenData, encoding: .utf8) ?? ""
    }
    
    public var stderr: String {
        return String(data: stderrPipe.writtenData, encoding: .utf8) ?? ""
    }
    
    public func start() throws {
        try forEachPipe {
            try $0.start()
        }
    }
    
    public func stop() throws {
        try forEachPipe {
            try $0.stop()
        }
    }
    
    private func forEachPipe(_ closure: (RedirectingPipe) throws -> ()) rethrows {
        for pipe in [stdoutPipe, stderrPipe] {
            try closure(pipe)
        }
    }
}
