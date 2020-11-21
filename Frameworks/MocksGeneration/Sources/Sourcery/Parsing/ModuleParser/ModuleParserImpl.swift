import PathKit
import SourceryFramework
import SourceryRuntime
import Foundation

public final class ModuleParserImpl: ModuleParser {
    private let sourceFileParser: SourceFileParser
    
    public init(sourceFileParser: SourceFileParser) {
        self.sourceFileParser = sourceFileParser
    }
    
    public func parse(paths: [Path], moduleName: String) throws -> ParsedModule {
        let sourceFiles = try paths.map {
            try sourceFileParser.parse(
                path: $0,
                moduleName: moduleName
            )
        }
        
        return ParsedModule(
            moduleScope: moduleScope(
                sourceFiles: sourceFiles,
                moduleName: moduleName
            ),
            sourceFiles: sourceFiles
        )
    }
    
    private func moduleScope(
        sourceFiles: [ParsedSourceFile],
        moduleName: String)
        -> ParsedModuleScope
    {
        var types: [Type] = []
        var functions: [SourceryMethod] = []
        var typealiases: [Typealias] = []
        
        sourceFiles.forEach { sourceFile in
            typealiases += sourceFile.types.typealiases
            types += sourceFile.types.types
            functions += sourceFile.functions
        }

        (types, functions, typealiases) = Composer.uniqueTypesAndFunctions(
            FileParserResult(
                path: nil,
                module: moduleName,
                types: types,
                functions: functions,
                typealiases: typealiases
            )
        )
        
        return ParsedModuleScope(
            moduleName: moduleName,
            types: Types(
                types: types,
                typealiases: typealiases
            ),
            functions: functions
        )
    }
}
