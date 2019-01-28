public final class AllureAttachment: Encodable {
    public let name: String
    public let source: String
    public let type: AllureAttachmentType
    
    public init(
        name: String,
        source: String,
        type: AllureAttachmentType)
    {
        self.name = name
        self.source = source
        self.type = type
    }
    
    public convenience init(
        name: String,
        source: String)
    {
        self.init(
            name: name,
            source: source,
            type: AllureAttachmentType(fileExtension: (source as NSString).pathExtension)
        )
    }
}
