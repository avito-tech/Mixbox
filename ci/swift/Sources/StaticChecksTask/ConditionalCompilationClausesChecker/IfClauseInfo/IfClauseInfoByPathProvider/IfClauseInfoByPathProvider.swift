public protocol IfClauseInfoByPathProvider {
    func ifClauseInfo(path: String) -> IfClauseInfo?
}
