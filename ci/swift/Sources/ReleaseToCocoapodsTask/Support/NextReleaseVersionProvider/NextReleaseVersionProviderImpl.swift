import Git
import CiFoundation

public final class NextReleaseVersionProviderImpl: NextReleaseVersionProvider {
    private let gitTagsProvider: GitTagsProvider
    private let gitRevListProvider: GitRevListProvider
    private let repoRootProvider: RepoRootProvider
    
    private let branch = "master"
    
    private struct VersionTag {
        let version: Version
        let revision: String
    }
    
    public init(
        gitTagsProvider: GitTagsProvider,
        gitRevListProvider: GitRevListProvider,
        repoRootProvider: RepoRootProvider)
    {
        self.gitTagsProvider = gitTagsProvider
        self.gitRevListProvider = gitRevListProvider
        self.repoRootProvider = repoRootProvider
    }
    
    public func nextReleaseVersion(
        majorVersion: Int,
        minorVersion: Int)
        throws
        -> Version
    {
        let repoRoot = try repoRootProvider.repoRootPath()
        
        let versionTags = try gitTagsProvider
            .gitTags(repoRoot: repoRoot)
            .compactMap { tag -> VersionTag? in
                guard let version = Version(versionString: tag.name) else {
                    return nil
                }
                
                return VersionTag(
                    version: version,
                    revision: tag.sha
                )
            }
        
        let versionTagsByRevision = Dictionary(
            grouping: versionTags,
            by: {
                $0.revision
            }
        )
        
        var versionTagByRevision: [String: VersionTag] = [:]
        
        for (revision, versionTags) in versionTagsByRevision {
            switch versionTags.count {
            case 0:
                // no releases
                continue
            case 1:
                versionTagByRevision[revision] = versionTags[0]
            default:
                throw ErrorString(
                    "Unexpected case: multiple released versions for same commit hash \(revision)"
                )
            }
        }
        
        let masterRevisions = try gitRevListProvider.revList(
            repoRoot: repoRoot,
            branch: branch
        )
        
        let masterTagsFromNewestToOldest = masterRevisions.compactMap { revision in
            versionTagByRevision[revision]
        }
        
        guard let latestVersionTag = masterTagsFromNewestToOldest.first else {
            throw ErrorString("No previous version tag found.")
        }
        
        guard let indexOfLatestVersionRevision = masterRevisions
                .firstIndex(of: latestVersionTag.revision)
        else {
            // Impossible case if previous code worked correctly
            throw ErrorString("Internal error: can't find index of latest released revision in array")
        }
        
        return try nextReleaseVersion(
            latestVersion: latestVersionTag.version,
            distanceToLatestReleaseInNumberOfRevisions: indexOfLatestVersionRevision,
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
        let isMajorVersionIncrement = (majorVersion == latestVersion.major + 1 && minorVersion == latestVersion.minor)
        let isMinorVersionIncrement = (minorVersion == latestVersion.minor + 1 && majorVersion == latestVersion.major)
        let isPatchVersionIncrement = (minorVersion == latestVersion.minor && majorVersion == latestVersion.major)
        
        if isMajorVersionIncrement || isMinorVersionIncrement {
            return Version(
                major: majorVersion,
                minor: minorVersion,
                patch: 0
            )
        } else if isPatchVersionIncrement {
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
