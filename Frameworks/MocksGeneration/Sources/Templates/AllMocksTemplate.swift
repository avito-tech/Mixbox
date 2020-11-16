public final class AllMocksTemplate {
    private let parsedSourceFiles: ParsedSourceFiles
    
    public init(parsedSourceFiles: ParsedSourceFiles) {
        self.parsedSourceFiles = parsedSourceFiles
    }
    
    public func render() throws -> String {
        let imports =
        """
        import MixboxMocksRuntime
        import MixboxFoundation
        import MixboxTestsFoundation
        """
        
        let mocks = try parsedSourceFiles.sourceFiles.flatMap { sourceFile in
            try sourceFile.types.protocols.map {
                try MockTemplate(protocolType: $0).render()
            }
        }
        
        return ([imports] + mocks).joined(separator: "\n\n") + "\n"
    }
}
