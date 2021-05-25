import MixboxReflection

public protocol ViewWithUtilities {
}

extension ViewWithUtilities {
    // Shorthand, can be used to print view configuration, for example.
    public var valueCodeGenerator: ValueCodeGenerator {
        return ValueCodeGeneratorImpl(
            indentation: "    ",
            newLineCharacter: "\n",
            immutableValueReflectionProvider: ImmutableValueReflectionProviderImpl()
        )
    }
}
