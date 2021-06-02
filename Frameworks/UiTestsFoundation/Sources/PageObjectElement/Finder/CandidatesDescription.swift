import MixboxTestsFoundation

public final class CandidatesDescription {
    public let description: String
    public let attachments: [Attachment]
    
    public init(
        description: String,
        attachments: [Attachment])
    {
        self.description = description
        self.attachments = attachments
    }
}
