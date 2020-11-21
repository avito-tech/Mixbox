public final class AllMocksTemplate {
    private let parsedModule: ParsedModule
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
        parsedModule: ParsedModule,
        destinationModuleName: String)
    {
        self.parsedModule = parsedModule
        self.destinationModuleName = destinationModuleName
    }
    
    public func render() -> String {
        var moduleNames: Set = [
            "MixboxMocksRuntime",
            "MixboxFoundation",
            "MixboxTestsFoundation"
        ]
        
        moduleNames.insert(parsedModule.moduleScope.moduleName)
        
        moduleNames.formUnion(
            parsedModule.moduleScope.allImports
        )
        
        moduleNames.remove(destinationModuleName)
        
        let header = "// swiftlint:disable all"
        
        let imports = moduleNames
            .sorted()
            .map { "import \($0)" }
            .joined(separator: "\n")
        
        let mocks = parsedModule.moduleScope.types.protocols.map {
            MockTemplate(protocolType: $0).render()
        }
        
        return ([header, imports] + mocks).joined(separator: "\n\n") + "\n"
    }
}
