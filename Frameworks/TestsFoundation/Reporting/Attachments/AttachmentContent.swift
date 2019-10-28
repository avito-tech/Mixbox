public enum AttachmentContent: Equatable {
    case screenshot(UIImage) // TODO: Rename to `image`
    case text(String)
    case json(String)
    case attachments([Attachment])
    
    static func jsonWithDictionary(_ dictionary: [String: Any]) -> AttachmentContent? {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted),
            let string = String(data: data, encoding: .utf8)
            else
        {
            return nil
        }
        
        return .json(string)
    }
    
    public static func ==(left: AttachmentContent, right: AttachmentContent) -> Bool {
        switch (left, right) {
        case let (.screenshot(left), .screenshot(right)):
            return left == right
        case let (.text(left), .text(right)):
            return left == right
        case let (.json(left), .json(right)):
            return left == right
        case let (.attachments(left), .attachments(right)):
            return left == right
        default:
            return false
        }
    }
}
