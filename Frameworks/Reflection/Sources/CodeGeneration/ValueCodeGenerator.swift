public protocol ValueCodeGenerator {
    // Generates code that represents a `value`.
    // Currently there is no limitations on correctness of the generated code,
    // so asssume it should be a Swift-like pseudocode.
    //
    // If `typeCanBeInferredFromContext` is `true` then code can be simlified, for
    // example, types can be removed. For example, it can generate `.myEnumCase` instead
    // of `MyEnum.myEnumCase`, which will be a shortened version.
    func generateCode(
        value: Any,
        typeCanBeInferredFromContext: Bool)
        -> String
}
