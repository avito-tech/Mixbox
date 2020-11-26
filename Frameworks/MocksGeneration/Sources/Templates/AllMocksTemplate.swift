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
    
    public func render() throws -> String {
        var moduleNamesForImporting: Set = [
            "MixboxFoundation",
            "MixboxMocksRuntime",
            "MixboxTestsFoundation"
        ]
        
        moduleNamesForImporting.formUnion(parsedModule.moduleScope.allImports)
        moduleNamesForImporting.remove(destinationModuleName)
        
        var testableModuleNamesForImporting: Set = [
            parsedModule.moduleScope.moduleName
        ]
        
        testableModuleNamesForImporting.remove(destinationModuleName)
        
        // If module should be testable, we can't import it without @testable,
        // so we remove it from the list of not testable modules and not otherwise
        testableModuleNamesForImporting.forEach {
            moduleNamesForImporting.remove($0)
        }
        
        let header = "// swiftlint:disable all"
        
        let imports = moduleNamesForImporting
            .sorted()
            .map { "import \($0)" }
        
        let testableImports = testableModuleNamesForImporting
            .sorted()
            .map { "@testable import \($0)" }
        
        let joinedImports = (imports + testableImports).joined(separator: "\n")
        
        let mocks = try parsedModule.moduleScope.types.protocols.map {
            try MockTemplate(
                protocolType: $0,
                moduleName: parsedModule.moduleScope.moduleName
            ).render()
        }
        
        return ([header, joinedImports] + mocks).joined(separator: "\n\n") + "\n"
    }
}
