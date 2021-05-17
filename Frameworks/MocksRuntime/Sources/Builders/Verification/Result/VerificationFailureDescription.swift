import MixboxFoundation

public final class VerificationFailureDescription {
    public let message: String
    public let fileLine: FileLine
    
    public init(message: String, fileLine: FileLine) {
        self.message = message
        self.fileLine = fileLine
    }
}
