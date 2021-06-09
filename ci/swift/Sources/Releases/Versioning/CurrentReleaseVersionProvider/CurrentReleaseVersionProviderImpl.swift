import CiFoundation

public final class CurrentReleaseVersionProviderImpl: CurrentReleaseVersionProvider {
    private let repositoryVersioningInfoProvider: RepositoryVersioningInfoProvider
    
    public init(
        repositoryVersioningInfoProvider: RepositoryVersioningInfoProvider)
    {
        self.repositoryVersioningInfoProvider = repositoryVersioningInfoProvider
    }
    
    public func currentReleaseVersion(
        commitHashToRelease: String,
        releaseBranchName: String)
        throws
        -> Version
    {
        let repositoryVersioningInfo = try repositoryVersioningInfoProvider.repositoryVersioningInfo(
            commitHashToRelease: commitHashToRelease,
            releaseBranchName: releaseBranchName
        )
        
        guard repositoryVersioningInfo.latestVersionTag.revision == commitHashToRelease else {
            throw ErrorString(
                """
                `commitHashToRelease` is expected to equal to commit of latest version.
                Commit hash to release: \(commitHashToRelease)
                Latest version commit hash: \(repositoryVersioningInfo.latestVersionTag.revision)
                Latest version: \(repositoryVersioningInfo.latestVersionTag.version.toString())
                """
            )
        }
        
        return repositoryVersioningInfo.latestVersionTag.version
    }
}
