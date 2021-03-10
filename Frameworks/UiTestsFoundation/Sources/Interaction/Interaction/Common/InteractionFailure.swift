import MixboxTestsFoundation

// Complete failure description for UI interaction
public final class InteractionFailure {
    public let message: String
    public let attachments: [Attachment]
    public let nestedFailures: [InteractionFailure]

    public init(
        message: String,
        attachments: [Attachment],
        nestedFailures: [InteractionFailure])
    {
        self.message = message
        self.attachments = attachments
        self.nestedFailures = nestedFailures
    }
}

// TODO: SRP
extension InteractionFailure {
    public func testFailureDescription() -> String {
        let joinedFailures = nestedFailures
            .map { $0.testFailureDescription() }
            .joined(separator: ", а также")
        
        switch nestedFailures.count {
        case 0:
            return message
        case 1:
            return "\(message), так как: \(joinedFailures)"
        default:
            return "\(message), так как: (\(joinedFailures))"
        }
    }
}
