public final class MacosProjectBuilderImpl: MacosProjectBuilder {
    private let xcodebuild: Xcodebuild
    
    public init(xcodebuild: Xcodebuild) {
        self.xcodebuild = xcodebuild
    }
    
    public func build(
        projectDirectoryFromRepoRoot: String,
        action: XcodebuildAction,
        scheme: String,
        workspaceName: String)
        throws
        -> XcodebuildResult
    {
        return try xcodebuild.build(
            xcodebuildPipeFilter: "tee",
            projectDirectoryFromRepoRoot: projectDirectoryFromRepoRoot,
            action: action,
            workspaceName: workspaceName,
            scheme: scheme,
            sdk: nil,
            destination: nil
        )
    }
}
