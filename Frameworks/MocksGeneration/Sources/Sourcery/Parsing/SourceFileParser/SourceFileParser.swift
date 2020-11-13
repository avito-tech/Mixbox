import PathKit

public protocol SourceFileParser {
    func parse(
        path: Path,
        moduleName: String)
        throws
        -> ParsedSourceFile
}
