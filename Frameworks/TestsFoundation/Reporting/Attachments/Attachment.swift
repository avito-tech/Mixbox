public final class Attachment: CustomDebugStringConvertible, Equatable {
    public let name: String
    public let content: AttachmentContent
    
    public init(
        name: String,
        content: AttachmentContent)
    {
        self.name = name
        self.content = content
    }
    
    public static func ==(left: Attachment, right: Attachment) -> Bool {
        return left.name == right.name
            && left.content == right.content
    }
    
    public var debugDescription: String {
        return """
        Attachment(
            name: \(name),
            content: \(content)
        )
        """
    }
}
