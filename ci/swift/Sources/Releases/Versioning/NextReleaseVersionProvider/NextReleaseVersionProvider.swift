public protocol NextReleaseVersionProvider {
    func nextReleaseVersion(
        majorVersion: Int,
        minorVersion: Int,
        commitHashToRelease: String,
        releaseBranchName: String)
        throws
        -> Version
}
