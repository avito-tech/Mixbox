import MixboxGenerators

public final class AnyGeneratorDynamicCallableFactory: DynamicCallableFactory {
    private let anyGenerator: AnyGenerator
    private let anyGeneratorDynamicCallableBehavior: AnyGeneratorDynamicCallableBehavior
    
    public init(
        anyGenerator: AnyGenerator,
        anyGeneratorDynamicCallableBehavior: AnyGeneratorDynamicCallableBehavior)
    {
        self.anyGenerator = anyGenerator
        self.anyGeneratorDynamicCallableBehavior = anyGeneratorDynamicCallableBehavior
    }
    
    public func dynamicCallable(
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
        -> DynamicCallable
    {
        return AnyGeneratorDynamicCallable(
            anyGenerator: anyGenerator,
            typeErasedAnyGenerator: TypeErasedAnyGeneratorImpl(
                anyGenerator: anyGenerator,
                specializations: generatorSpecializations
            ),
            anyGeneratorDynamicCallableBehavior: anyGeneratorDynamicCallableBehavior
        )
    }
}
