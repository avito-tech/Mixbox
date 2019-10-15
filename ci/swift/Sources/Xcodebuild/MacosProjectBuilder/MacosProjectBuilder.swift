public protocol MacosProjectBuilder {
    func build(
        projectDirectoryFromRepoRoot: String,
        action: XcodebuildAction,
        scheme: String,
        workspaceName: String)
        throws
        -> XcodebuildResult
}
