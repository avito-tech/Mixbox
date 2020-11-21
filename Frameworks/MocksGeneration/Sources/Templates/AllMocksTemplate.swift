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
            "MixboxFoundation",
            "MixboxMocksRuntime",
            "MixboxTestsFoundation"
        ]
        
        moduleNames.formUnion(parsedModule.moduleScope.allImports)
        moduleNames.remove(destinationModuleName)
        
        let testableMouleNames: Set = [
            parsedModule.moduleScope.moduleName
        ]
        
        // If module should be testable, we can't import it without @testable,
        // so we remove it from the list of not testable modules and not otherwise
        testableMouleNames.forEach {
            moduleNames.remove($0)
        }
        
        let header = "// swiftlint:disable all"
        
        let imports = moduleNames
            .sorted()
            .map { "import \($0)" }
        
        let testableImports = testableMouleNames
            .sorted()
            .map { "@testable import \($0)" }
        
        let joinedImports = (imports + testableImports).joined(separator: "\n")
        
        let mocks = parsedModule.moduleScope.types.protocols.map {
            MockTemplate(protocolType: $0).render()
        }
        
        return ([header, joinedImports] + mocks).joined(separator: "\n\n") + "\n"
    }
}
