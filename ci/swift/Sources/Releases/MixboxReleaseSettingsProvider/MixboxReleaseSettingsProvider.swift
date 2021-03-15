public protocol MixboxReleaseSettingsProvider {
    var majorVersion: Int { get }
    var minorVersion: Int { get }
    var releaseBranchName: String { get } // e.g. "master"
    var releaseRemoteName: String { get } // e.g. "origin"
    var releaseBranchFullName: String { get } // e.g. "origin/master"
}
