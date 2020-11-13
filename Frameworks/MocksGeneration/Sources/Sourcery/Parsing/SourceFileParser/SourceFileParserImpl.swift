import PathKit
import SourceryFramework
import SourceryRuntime
import Foundation

public final class SourceFileParserImpl: SourceFileParser {
    public init() {
    }
    
    public func parse(path: Path, moduleName: String) throws -> ParsedSourceFile {
        let contents = try NSString(
            contentsOfFile: path.string,
            encoding: String.Encoding.utf8.rawValue
        ) as String

        let fileParser = try FileParser(
            contents: contents,
            path: path,
            module: moduleName
        )
        
        let result = try fileParser.parse()
        
        return ParsedSourceFile(
            path: path,
            moduleName: moduleName,
            types: Types(types: result.types, typealiases: result.typealiases),
            functions: result.functions,
            sourceryInlineRanges: result.inlineRanges,
            sourceryInlineIndentations: result.inlineIndentations,
            modifiedDate: result.modifiedDate,
            sourceryVersion: result.sourceryVersion
        )
    }
}
