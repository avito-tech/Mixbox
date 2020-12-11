import MixboxGenerators

public final class CanNotProvideResultDynamicCallableFactory: DynamicCallableFactory {
    private let error: Error
    
    public init(error: Error) {
        self.error = error
    }
    
    public func dynamicCallable(
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
        -> DynamicCallable
    {
        return CanNotProvideResultDynamicCallable(
            error: error
        )
    }
}
