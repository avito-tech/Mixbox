import Destinations

// Note: tightly coupled with this repo and can not be reused.
public protocol Xcodebuild {
    func build(
        projectDirectoryFromRepoRoot: String,
        action: XcodebuildAction,
        workspaceName: String,
        scheme: String,
        sdk: String?,
        destination: String?)
        throws
        -> XcodebuildResult
}
