public final class Artifact {
    public let name: String
    public let content: ArtifactContent
    
    public init(
        name: String,
        content: ArtifactContent)
    {
        self.name = name
        self.content = content
    }
}

public enum ArtifactContent {
    case screenshot(UIImage)
    case text(String)
    case json(String)
    case artifacts([Artifact])
    
    static func jsonWithDictionary(_ dictionary: [String: Any]) -> ArtifactContent? {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted),
            let string = String(data: data, encoding: .utf8)
            else
        {
            return nil
        }
        return .json(string)
    }
}
