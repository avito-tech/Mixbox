public final class AllMocksTemplate {
    private let parsedSourceFiles: ParsedSourceFiles
    
    public init(parsedSourceFiles: ParsedSourceFiles) {
        self.parsedSourceFiles = parsedSourceFiles
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
