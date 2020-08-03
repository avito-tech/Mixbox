public final class NoopFileLineForFailureProvider: FileLineForFailureProvider {
    public init() {
    }
    
    public func fileLineForFailure() -> HeapFileLine? {
        return nil
    }
}
