import Foundation

public final class CocoapodsTrunkInfoResult {
    public final class Version {
        public let versionString: String
        public let releaseDate: Date
        
        public init(
            versionString: String,
            releaseDate: Date)
        {
            self.versionString = versionString
            self.releaseDate = releaseDate
        }
    }
    
    public final class Owner {
        public let name: String
        public let email: String
        
        public init(
            name: String,
            email: String)
        {
            self.name = name
            self.email = email
        }
    }
    
    public let podName: String
    public let versions: [Version]
    public let owners: [Owner]
    
    public init(
        podName: String,
        versions: [Version],
        owners: [Owner])
    {
        self.podName = podName
        self.versions = versions
        self.owners = owners
    }
}
