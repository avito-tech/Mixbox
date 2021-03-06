import Git
import CiFoundation

public final class NextReleaseVersionProviderImpl: NextReleaseVersionProvider {
    private let gitTagsProvider: GitTagsProvider
    private let gitRevListProvider: GitRevListProvider
    private let headCommitHashProvider: HeadCommitHashProvider
    private let releaseBranchName: String
    
    private struct VersionTag {
        let version: Version
        let revision: String
    }
    
    public init(
        gitTagsProvider: GitTagsProvider,
        gitRevListProvider: GitRevListProvider,
        headCommitHashProvider: HeadCommitHashProvider,
        releaseBranchName: String = "origin/master")
    {
        self.gitTagsProvider = gitTagsProvider
        self.gitRevListProvider = gitRevListProvider
        self.headCommitHashProvider = headCommitHashProvider
        self.releaseBranchName = releaseBranchName
    }
    
    // TODO: Split the function.
    // swiftlint:disable:next function_body_length
    public func nextReleaseVersion(
        majorVersion: Int,
        minorVersion: Int,
        commitHashToRelease: String)
        throws
        -> Version
    {
        let versionTags = try gitTagsProvider
            .gitTags()
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
        
        let releaseBranchRevisions = try gitRevListProvider.revList(
            branch: releaseBranchName
        )
        
        let headCommitHash = try headCommitHashProvider.headCommitHash()
        
        guard commitHashToRelease == headCommitHash else {
            throw ErrorString("Currently unsupported case. Commit to release is not HEAD.")
        }
        
        guard releaseBranchRevisions.first == headCommitHash else {
            throw ErrorString("Currently unsupported case. Top of \(releaseBranchName) branch is not HEAD.")
        }
        
        let releaseBranchTagsFromNewestToOldest = releaseBranchRevisions.compactMap { revision in
            versionTagByRevision[revision]
        }
        
        guard let latestVersionTag = releaseBranchTagsFromNewestToOldest.first else {
            throw ErrorString("No previous version tag found.")
        }
        
        guard let indexOfLatestVersionRevision = releaseBranchRevisions
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
