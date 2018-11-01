import MixboxFoundation

final class RedirectingPipe {
    private enum State {
        case initial
        case resumed(StartedRedirectingPipe)
        case suspended(StartedRedirectingPipe)
        
        var pipe: StartedRedirectingPipe? {
            switch self {
            case .initial:
                return nil
            case .resumed(let pipe):
                return pipe
            case .suspended(let pipe):
                return pipe
            }
        }
    }
    
    private let redirectedFileDescriptor: Int32
    private var state: State = .initial
    
    var writtenData: Data {
        return state.pipe?.writtenData ?? Data()
    }
    
    init(redirectedFileDescriptor: Int32) {
        self.redirectedFileDescriptor = redirectedFileDescriptor
    }
    
    func installHook() throws {
        switch state {
        case .initial:
            let pipe = try StartedRedirectingPipe(
                redirectedFileDescriptor: redirectedFileDescriptor
            )
            state = .suspended(pipe)
        case .suspended, .resumed:
            throw ErrorString("Can not installHook() RedirectingPipe: already installed")
        }
    }
    
    func resume() throws {
        switch state {
        case .initial:
            throw ErrorString("Can not start() RedirectingPipe: hook was not installed")
        case .suspended(let pipe):
            pipe.resume()
            state = .resumed(pipe)
        case .resumed:
            throw ErrorString("Can not start() RedirectingPipe: already started")
        }
    }
    
    func suspend() throws {
        switch state {
        case .initial:
            throw ErrorString("Can not stop() RedirectingPipe: never started")
        case .suspended:
            throw ErrorString("Can not stop() RedirectingPipe: already stopped")
        case .resumed(let pipe):
            pipe.suspend()
            self.state = .suspended(pipe)
        }
    }
    
    func uninstallHook() throws {
        try state.pipe?.uninstallHook()
        state = .initial
    }
}
