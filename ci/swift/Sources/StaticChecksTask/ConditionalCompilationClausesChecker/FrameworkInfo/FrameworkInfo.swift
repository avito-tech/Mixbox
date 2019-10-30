public final class FrameworkInfo {
    public let name: String
    public let requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: Bool
    
    public init(
        name: String,
        requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: Bool)
    {
        self.name = name
        self.requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds = requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds
    }
}
