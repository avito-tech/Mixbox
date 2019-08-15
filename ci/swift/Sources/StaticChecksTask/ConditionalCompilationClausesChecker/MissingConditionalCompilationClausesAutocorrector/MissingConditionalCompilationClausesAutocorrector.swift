public protocol MissingConditionalCompilationClausesAutocorrector {
    func autocorrect(missingConditionalCompilationClauses: [MissingConditionalCompilationClause]) throws
}
