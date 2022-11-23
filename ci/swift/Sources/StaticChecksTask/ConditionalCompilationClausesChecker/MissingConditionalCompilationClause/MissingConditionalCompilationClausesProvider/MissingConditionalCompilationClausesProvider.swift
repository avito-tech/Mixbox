public protocol MissingConditionalCompilationClausesProvider {
    func missingConditionalCompilationClauses(
    ) throws -> Set<MissingConditionalCompilationClause>
}
