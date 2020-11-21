// Doc: https://docs.swift.org/swift-book/ReferenceManual/GenericParametersAndArguments.html#grammar_generic-parameter-clause
// Only simple cases are handled. Ideally we should use grammar.
// Example: https://github.com/SwiftTools/SwiftGrammar
public final class GenericParameterClause {
    public let genericParameters: [GenericParameter]
    
    public init(genericParameters: [GenericParameter]) {
        self.genericParameters = genericParameters
    }
}
