#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol ByFieldsGeneratorResolver {
    func resolveByFieldsGenerator<T>() throws -> ByFieldsGenerator<T>
}

#endif
