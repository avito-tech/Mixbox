public class JsonSubspec: Codable {
    public let name: String
    public let dependencies: [String: [String]]?
    
    public init(
        name: String,
        dependencies: [String : [String]]?)
    {
        self.name = name
        self.dependencies = dependencies
    }
}
