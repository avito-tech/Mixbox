public protocol CurrentReleaseVersionProvider {
    func currentReleaseVersion(
        commitHashToRelease: String,
        releaseBranchName: String)
        throws
        -> Version
}
