public class JsonPodspec: Codable {
    public let name: String
    public let dependencies: [String: [String]]?
    public let frameworks: EitherArrayOrElement<String>?
    public let xcconfig: [String: String]?
    public let module_name: String
    public let version: String
    public let summary: String
    public let homepage: String
    public let license: String
    public let authors: [String: String]
    public let source: [String: String]
    public let requires_arc: Bool
    public let platforms: [String: String]
    public let source_files: String?
    public let swift_version: String
    public let subspecs: [JsonSubspec]?
    
    public init(
        name: String,
        dependencies: [String: [String]]?,
        frameworks: EitherArrayOrElement<String>,
        xcconfig: [String: String],
        module_name: String,
        version: String,
        summary: String,
        homepage: String,
        license: String,
        authors: [String: String],
        source: [String: String],
        requires_arc: Bool,
        platforms: [String: String],
        source_files: String,
        swift_version: String,
        subspecs: [JsonSubspec]?)
    {
        self.name = name
        self.dependencies = dependencies
        self.frameworks = frameworks
        self.xcconfig = xcconfig
        self.module_name = module_name
        self.version = version
        self.summary = summary
        self.homepage = homepage
        self.license = license
        self.authors = authors
        self.source = source
        self.requires_arc = requires_arc
        self.platforms = platforms
        self.source_files = source_files
        self.swift_version = swift_version
        self.subspecs = subspecs
    }
}
