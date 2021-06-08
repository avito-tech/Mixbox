import MixboxFoundation

public protocol FileLineForFailureProvider: AnyObject {
    func fileLineForFailure() -> RuntimeFileLine?
}
