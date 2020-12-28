public protocol ImmutableValueReflectionProvider {
    func reflection(value: Any) -> TypedImmutableValueReflection
}
