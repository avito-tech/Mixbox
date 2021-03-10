public protocol NextReleaseVersionProvider {
    func nextReleaseVersion(
        majorVersion: Int,
        minorVersion: Int,
        commitHashToRelease: String)
        throws
        -> Version
}

extension NextReleaseVersionProvider {
    public func nextReleaseVersion(
        commitHashToRelease: String)
        throws
        -> Version
    {
        return try nextReleaseVersion(
            majorVersion: MixboxVersion.major,
            minorVersion: MixboxVersion.minor,
            commitHashToRelease: commitHashToRelease
        )
    }
}
