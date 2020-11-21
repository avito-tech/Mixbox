import SourceryRuntime

public final class ParsedModuleScope {
    public let moduleName: String
    public let types: Types
    public let functions: [SourceryMethod]
    
    public init(
        moduleName: String,
        types: Types,
        functions: [SourceryMethod])
    {
        self.moduleName = moduleName
        self.types = types
        self.functions = functions
    }
}

extension ParsedModuleScope {
    public var allImports: Set<String> {
        return Set(types.types.flatMap {
            $0.imports
        })
    }
}
