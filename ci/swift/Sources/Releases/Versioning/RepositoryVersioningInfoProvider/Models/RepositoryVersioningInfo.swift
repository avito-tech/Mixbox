public final class RepositoryVersioningInfo {
    public init(
        latestVersionTag: VersionTag,
        releaseBranchTagsFromNewestToOldest: [VersionTag],
        indexOfLatestVersionRevision: Int)
    {
        self.latestVersionTag = latestVersionTag
        self.releaseBranchTagsFromNewestToOldest = releaseBranchTagsFromNewestToOldest
        self.indexOfLatestVersionRevision = indexOfLatestVersionRevision
    }
    
    public let latestVersionTag: VersionTag
    public let releaseBranchTagsFromNewestToOldest: [VersionTag]
    public let indexOfLatestVersionRevision: Int
    
    public var distanceToLatestReleaseInNumberOfRevisions: Int {
        return indexOfLatestVersionRevision
    }
}
