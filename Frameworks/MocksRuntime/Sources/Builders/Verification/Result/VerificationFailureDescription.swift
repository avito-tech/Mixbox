import MixboxFoundation

public final class VerificationFailureDescription {
    public var message: String
    public var fileLine: FileLine
    
    public init(message: String, fileLine: FileLine) {
        self.message = message
        self.fileLine = fileLine
    }
}
