import MixboxFoundation

final class RedirectingPipe {
    private enum State {
        case initial
        case started(StartedRedirectingPipe)
        case stopped(StartedRedirectingPipe)
        
        var pipe: StartedRedirectingPipe? {
            switch self {
            case .initial:
                return nil
            case .started(let pipe):
                return pipe
            case .stopped(let pipe):
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
    
    func start() throws {
        switch state {
        case .initial, .stopped:
            break
        case .started:
            throw ErrorString("Can not start() RedirectingPipe: already started")
        }
        
        let pipe = try StartedRedirectingPipe(
            redirectedFileDescriptor: redirectedFileDescriptor
        )
        
        state = .started(pipe)
    }
    
    func stop() throws {
        switch state {
        case .initial:
            throw ErrorString("Can not stop() RedirectingPipe: never started")
        case .stopped:
            throw ErrorString("Can not stop() RedirectingPipe: already stopped")
        case .started(let pipe):
            try pipe.stop()
            self.state = .stopped(pipe)
        }
    }
}
