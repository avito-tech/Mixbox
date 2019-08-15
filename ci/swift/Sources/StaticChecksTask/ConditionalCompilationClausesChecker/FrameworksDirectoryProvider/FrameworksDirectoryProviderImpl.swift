import Git

public final class FrameworksDirectoryProviderImpl: FrameworksDirectoryProvider {
    private let repoRootProvider: RepoRootProvider
    
    public init(repoRootProvider: RepoRootProvider) {
        self.repoRootProvider = repoRootProvider
    }
    
    public func frameworksDirectory() throws -> String {
        let repoRootPath = try repoRootProvider.repoRootPath()
        
        return "\(repoRootPath)/Frameworks"
    }
}
