import PathKit

public protocol ModuleParser {
    func parse(
        paths: [Path],
        moduleName: String)
        throws
        -> ParsedModule
}
