import Git
import CiFoundation

public final class RepositoryVersioningInfoProviderImpl: RepositoryVersioningInfoProvider {
    private let gitTagsProvider: GitTagsProvider
    private let gitRevListProvider: GitRevListProvider
    private let headCommitHashProvider: HeadCommitHashProvider
    
    public init(
        gitTagsProvider: GitTagsProvider,
        gitRevListProvider: GitRevListProvider,
        headCommitHashProvider: HeadCommitHashProvider)
    {
        self.gitTagsProvider = gitTagsProvider
        self.gitRevListProvider = gitRevListProvider
        self.headCommitHashProvider = headCommitHashProvider
    }

    // swiftlint:disable:next function_body_length
    public func repositoryVersioningInfo(
        commitHashToRelease: String,
        releaseBranchName: String)
        throws
        -> RepositoryVersioningInfo
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
        
        return RepositoryVersioningInfo(
            latestVersionTag: latestVersionTag,
            releaseBranchTagsFromNewestToOldest: releaseBranchTagsFromNewestToOldest,
            indexOfLatestVersionRevision: indexOfLatestVersionRevision
        )
    }
}
