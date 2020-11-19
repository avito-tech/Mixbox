public final class AllMocksTemplate {
    private let parsedSourceFiles: ParsedSourceFiles
    private let destinationModuleName: String
    
    /// `destinationModuleName`: name of module that will include generated code.
    ///
    /// It will be used to remove import of this module to avoid such warning:
    ///
    /// ```
    /// File 'MyFile.swift' is part of module 'MyModule'; ignoring import
    /// ```
    ///
    public init(
        parsedSourceFiles: ParsedSourceFiles,
        destinationModuleName: String)
    {
        self.parsedSourceFiles = parsedSourceFiles
        self.destinationModuleName = destinationModuleName
    }
    
    public func render() throws -> String {
        var moduleNames: Set = [
            "MixboxMocksRuntime",
            "MixboxFoundation",
            "MixboxTestsFoundation"
        ]
        
        moduleNames.formUnion(
            parsedSourceFiles.sourceFiles.flatMap {
                [$0.moduleName] + $0.types.types.flatMap { $0.imports }
            }
        )
        
        moduleNames.remove(destinationModuleName)
        
        let imports = moduleNames
            .sorted()
            .map { "import \($0)" }
            .joined(separator: "\n")
        
        let mocks = try parsedSourceFiles.sourceFiles.flatMap { sourceFile in
            try sourceFile.types.protocols.map {
                try MockTemplate(protocolType: $0).render()
            }
        }
        
        return ([imports] + mocks).joined(separator: "\n\n") + "\n"
    }
}
