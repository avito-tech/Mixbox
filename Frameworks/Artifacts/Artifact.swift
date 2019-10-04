// TODO: Rename to attachment or something
public final class Artifact: CustomDebugStringConvertible, Equatable {
    public let name: String
    public let content: ArtifactContent
    
    public init(
        name: String,
        content: ArtifactContent)
    {
        self.name = name
        self.content = content
    }
    
    public static func ==(left: Artifact, right: Artifact) -> Bool {
        return left.name == right.name
            && left.content == right.content
    }
    
    public var debugDescription: String {
        return """
        Artifact(
            name: \(name),
            content: \(content)
        )
        """
    }
}

public enum ArtifactContent: Equatable {
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
    
    public static func ==(left: ArtifactContent, right: ArtifactContent) -> Bool {
        switch (left, right) {
        case let (.screenshot(left), .screenshot(right)):
            return left == right
        case let (.text(left), .text(right)):
            return left == right
        case let (.json(left), .json(right)):
            return left == right
        case let (.artifacts(left), .artifacts(right)):
            return left == right
        default:
            return false
        }
    }
}
