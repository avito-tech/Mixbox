public protocol NextReleaseVersionProvider {
    func nextReleaseVersion(
        majorVersion: Int,
        minorVersion: Int)
        throws
        -> Version
}

extension NextReleaseVersionProvider {
    public func nextReleaseVersion() throws -> Version {
        return try nextReleaseVersion(
            majorVersion: MixboxVersion.major,
            minorVersion: MixboxVersion.minor
        )
    }
}
