import MixboxFoundation

public protocol VerificationBuilder: AnyObject {
    init(mockManager: MockManager, fileLine: FileLine)
}
