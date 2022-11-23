public protocol MissingConditionalCompilationClausesAutocorrector {
    func autocorrect(
        missingConditionalCompilationClauses: Set<MissingConditionalCompilationClause>
    ) throws
}
