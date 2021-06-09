public protocol RepositoryVersioningInfoProvider {
    func repositoryVersioningInfo(
        commitHashToRelease: String,
        releaseBranchName: String)
        throws
        -> RepositoryVersioningInfo
}
