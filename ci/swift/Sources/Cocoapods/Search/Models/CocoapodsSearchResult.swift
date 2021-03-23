public final class CocoapodsSearchResult {
    public final class Pod {
        public let name: String
        public let latestVersion: String
        public let description: String
        public let usage: String
        public let homepage: String?
        public let source: String?
        public let versions: [String: [String]]?
        public let author: String?
        public let license: String?
        public let platforms: [String: String]?
        public let stars: Int?
        public let forks: Int?
        
        public init(
            name: String,
            latestVersion: String,
            description: String,
            usage: String,
            homepage: String?,
            source: String?,
            versions: [String: [String]]?,
            author: String?,
            license: String?,
            platforms: [String: String]?,
            stars: Int?,
            forks: Int?)
        {
            self.name = name
            self.latestVersion = latestVersion
            self.description = description
            self.usage = usage
            self.homepage = homepage
            self.source = source
            self.versions = versions
            self.author = author
            self.license = license
            self.platforms = platforms
            self.stars = stars
            self.forks = forks
        }
    }
    
    public let pods: [Pod]

    public init(
        pods: [Pod])
    {
        self.pods = pods
    }
}
