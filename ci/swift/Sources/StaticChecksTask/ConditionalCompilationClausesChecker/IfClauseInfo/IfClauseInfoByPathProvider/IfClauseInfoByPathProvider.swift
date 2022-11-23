public protocol IfClauseInfoByPathProvider {
    func ifClauseInfo(
        frameworkName: String,
        filePath: String
    ) -> IfClauseInfo?
}
