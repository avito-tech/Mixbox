public protocol ByFieldsGeneratorResolver {
    func resolveByFieldsGenerator<T>() throws -> ByFieldsGenerator<T>
}
