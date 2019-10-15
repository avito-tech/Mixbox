import Git
import Foundation

public final class GemfileLocationProviderImpl: GemfileLocationProvider {
    private let repoRootProvider: RepoRootProvider
    private let gemfileBasename: String
    
    public init(
        repoRootProvider: RepoRootProvider,
        gemfileBasename: String)
    {
        self.repoRootProvider = repoRootProvider
        self.gemfileBasename = gemfileBasename
    }
    
    public func gemfileLocation() throws -> String {
        let repoRootPath = try repoRootProvider.repoRootPath()
        return ("\(repoRootPath)/ci/gemfiles/\(gemfileBasename)" as NSString).standardizingPath
    }
}
