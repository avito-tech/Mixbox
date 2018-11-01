//
// OutputHook allows you to intercept stdout/stderr (aka "logs") of current process,
// you can install the hook and get strings containing everything that was printed to stdout/stderr.
//
// WARNING: OutputHook is not reliable! It can crash app, see descriptions for functions.
//
public final class OutputHook {
    private let stdoutPipe = RedirectingPipe(redirectedFileDescriptor: fileno(Foundation.stdout))
    private let stderrPipe = RedirectingPipe(redirectedFileDescriptor: fileno(Foundation.stderr))
    
    public static let instance = OutputHook()
    
    private init() {
    }
    
    public var stdout: String {
        return String(data: stdoutPipe.writtenData, encoding: .utf8) ?? ""
    }
    
    public var stderr: String {
        return String(data: stderrPipe.writtenData, encoding: .utf8) ?? ""
    }
    
    // Sets up the hook.
    // THIS CAN NOT BE UNDONE!
    // THIS CAN CRASH YOUR APP if something is printed in background,
    // so it can be set up early in tests (e.g. in Principal class).
    // I don't recommend use it in production code.
    public func installHook() throws {
        try forEachPipe {
            try $0.installHook()
        }
    }
    
    // Resets the data (stdout, stderr) and start collecting it.
    public func resume() throws {
        try forEachPipe {
            try $0.resume()
        }
    }
    
    // Stops appending data. Doesn't reset data.
    // Doesn't reset hooks.
    public func suspend() throws {
        try forEachPipe {
            try $0.suspend()
        }
    }
    
    // THIS CAN CRASH YOUR APP if something is printed in background!
    // Can cause SIGPIPE. I highly recommend to not use it at all.
    public func uninstallHook() throws {
        try forEachPipe {
            try $0.uninstallHook()
        }
    }
    
    private func forEachPipe(_ closure: (RedirectingPipe) throws -> ()) rethrows {
        for pipe in [stdoutPipe, stderrPipe] {
            try closure(pipe)
        }
    }
}
