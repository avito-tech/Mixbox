import CiFoundation

public final class NextReleaseVersionProviderImpl: NextReleaseVersionProvider {
    private let repositoryVersioningInfoProvider: RepositoryVersioningInfoProvider
    
    public init(
        repositoryVersioningInfoProvider: RepositoryVersioningInfoProvider)
    {
        self.repositoryVersioningInfoProvider = repositoryVersioningInfoProvider
    }
    
    public func nextReleaseVersion(
        majorVersion: Int,
        minorVersion: Int,
        commitHashToRelease: String,
        releaseBranchName: String)
        throws
        -> Version
    {
        let repositoryVersioningInfo = try repositoryVersioningInfoProvider.repositoryVersioningInfo(
            commitHashToRelease: commitHashToRelease,
            releaseBranchName: releaseBranchName
        )
        
        guard repositoryVersioningInfo.latestVersionTag.revision != commitHashToRelease else {
            throw ErrorString(
                """
                This commit hash is already released: \(commitHashToRelease) \
                (\(repositoryVersioningInfo.latestVersionTag.version.toString())).
                """
            )
        }
        
        return try nextReleaseVersion(
            latestVersion: repositoryVersioningInfo.latestVersionTag.version,
            distanceToLatestReleaseInNumberOfRevisions: repositoryVersioningInfo.distanceToLatestReleaseInNumberOfRevisions,
            majorVersion: majorVersion,
            minorVersion: minorVersion
        )
    }
    
    private func nextReleaseVersion(
        latestVersion: Version,
        distanceToLatestReleaseInNumberOfRevisions: Int,
        majorVersion: Int,
        minorVersion: Int)
        throws
        -> Version
    {
        let isMajorVersionIncrementOnly = (majorVersion == latestVersion.major + 1 && minorVersion == latestVersion.minor)
        let isMinorVersionIncrementOnly = (minorVersion == latestVersion.minor + 1 && majorVersion == latestVersion.major)
        let isNotMinorOrMajorVersionIncrement = (minorVersion == latestVersion.minor && majorVersion == latestVersion.major)
        
        if isMajorVersionIncrementOnly || isMinorVersionIncrementOnly {
            return Version(
                major: majorVersion,
                minor: minorVersion,
                patch: 0
            )
        } else if isNotMinorOrMajorVersionIncrement {
            return Version(
                major: majorVersion,
                minor: minorVersion,
                patch: latestVersion.patch + distanceToLatestReleaseInNumberOfRevisions
            )
        } else {
            throw ErrorString(
                """
                Unexpected version increment. \
                Seems like you jump several minor or major versions at once. \
                Example: jumping from 2.0.0 to 4.0.0 is unexpected (to 3.0.0 is expected). \
                Example: jumping from 2.1.0 to 3.1.0 is unexpected (to 3.0.0 is expected).
                """
            )
        }
    }
}
