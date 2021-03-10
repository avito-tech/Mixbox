import MixboxFoundation

public final class NoopFileLineForFailureProvider: FileLineForFailureProvider {
    public init() {
    }
    
    public func fileLineForFailure() -> RuntimeFileLine? {
        return nil
    }
}
