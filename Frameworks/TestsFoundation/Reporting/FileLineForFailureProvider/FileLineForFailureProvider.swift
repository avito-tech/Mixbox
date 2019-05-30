public protocol FileLineForFailureProvider: class {
    func fileLineForFailure() -> HeapFileLine?
}
