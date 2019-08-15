public protocol MissingConditionalCompilationClausesProvider {
    func missingConditionalCompilationClauses()
        throws
        -> [MissingConditionalCompilationClause]
}
