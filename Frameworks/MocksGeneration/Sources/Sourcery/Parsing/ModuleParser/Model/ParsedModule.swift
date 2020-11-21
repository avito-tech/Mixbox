public final class ParsedModule {
    public let moduleScope: ParsedModuleScope
    public let sourceFiles: [ParsedSourceFile]
    
    public init(
        moduleScope: ParsedModuleScope,
        sourceFiles: [ParsedSourceFile])
    {
        self.moduleScope = moduleScope
        self.sourceFiles = sourceFiles
    }
}
