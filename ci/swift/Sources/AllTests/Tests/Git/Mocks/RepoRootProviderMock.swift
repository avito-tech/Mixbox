import Git

public final class RepoRootProviderMock: RepoRootProvider {
    private let repoRootPathStub: String
    
    public init(repoRootPath: String) {
        self.repoRootPathStub = repoRootPath
    }
    
    public func repoRootPath() throws -> String {
        return repoRootPathStub
    }
}
