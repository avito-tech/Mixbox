import SourceryRuntime
import Foundation
import PathKit

public final class ParsedSourceFile {
    public let path: Path
    public let moduleName: String
    public let types: Types
    public let functions: [SourceryMethod]
    public let sourceryInlineRanges: [String: NSRange]
    public let sourceryInlineIndentations: [String: String]
    public let modifiedDate: Date
    public let sourceryVersion: String
    
    public init(
        path: Path,
        moduleName: String,
        types: Types,
        functions: [SourceryMethod],
        sourceryInlineRanges: [String: NSRange],
        sourceryInlineIndentations: [String: String],
        modifiedDate: Date,
        sourceryVersion: String)
    {
        self.path = path
        self.moduleName = moduleName
        self.types = types
        self.functions = functions
        self.sourceryInlineRanges = sourceryInlineRanges
        self.sourceryInlineIndentations = sourceryInlineIndentations
        self.modifiedDate = modifiedDate
        self.sourceryVersion = sourceryVersion
    }
}
