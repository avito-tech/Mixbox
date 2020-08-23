public protocol CocoapodsSearchOutputParser {
    func parse(output: String) throws -> CocoapodsSearchResult
}
