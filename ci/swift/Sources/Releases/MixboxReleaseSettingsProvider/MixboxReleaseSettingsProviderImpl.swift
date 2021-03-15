// Mixbox major & minor version is hardcoded here.
// This is the source of truth.
public final class MixboxReleaseSettingsProviderImpl: MixboxReleaseSettingsProvider {
    public init() {
    }
    
    public var majorVersion: Int {
        return 0
    }
    
    public var minorVersion: Int {
        return 2
    }
    
    public var releaseBranchName: String {
        return "master"
    }
    
    public var releaseRemoteName: String {
        return "origin"
    }
    
    public var releaseBranchFullName: String {
        return "\(releaseRemoteName)/\(releaseBranchName)"
    }
}
