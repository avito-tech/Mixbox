#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol TypeErasedGeneratableByFields {
    static func typeErasedByFieldsGenerator() -> Any
}

#endif
