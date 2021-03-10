public final class NoopTestFailingGeneratorObserver: TestFailingGeneratorObserver {
    public init() {
    }
    
    public func didGenerate(type: Any.Type, value: Any) {
    }
}
