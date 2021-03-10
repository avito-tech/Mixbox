import MixboxFoundation

public protocol FileLineForFailureProvider: class {
    func fileLineForFailure() -> RuntimeFileLine?
}
