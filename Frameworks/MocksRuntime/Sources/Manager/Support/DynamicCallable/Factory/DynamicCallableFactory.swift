import MixboxGenerators

public protocol DynamicCallableFactory {
    func dynamicCallable(
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
        -> DynamicCallable
}
