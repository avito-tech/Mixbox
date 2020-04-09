import MixboxDi

public protocol TypeErasedDefaultGeneratorProvider {
    static func typeErasedDefaultGenerator(dependencyResolver: DependencyResolver) throws -> Any
}
