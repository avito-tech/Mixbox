public protocol CocoapodsTrunkInfoOutputParser {
    func parse(output: String) throws -> CocoapodsTrunkInfoResult
}
