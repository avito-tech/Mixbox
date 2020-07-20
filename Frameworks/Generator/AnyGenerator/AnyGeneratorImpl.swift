import MixboxDi
import MixboxFoundation

public final class AnyGeneratorImpl: AnyGenerator {
    private let dependencyResolver: DependencyResolver
    
    public init(dependencyResolver: DependencyResolver) {
        self.dependencyResolver = dependencyResolver
    }
    
    public func generate<T>() throws -> T {
        let generator = try resolveGenerator() as Generator<T>
        return try generator.generate()
    }
    
    private func resolveGenerator<T>() throws -> Generator<T> {
        do {
            return try dependencyResolver.resolve()
        } catch let resolveError {
            do {
                // The following hack will allow to generate object of type `T` automatically without
                // prior registration in DI. This will allow to get rid of a lot of boilerplate code in tests.
                if let type = T.self as? TypeErasedDefaultGeneratorProvider.Type {
                    let typeErasedGenerator = try type.typeErasedDefaultGenerator(dependencyResolver: dependencyResolver)
                    
                    if let generator = typeErasedGenerator as? Generator<T> {
                        return generator
                    } else {
                        throw ErrorString(
                            """
                            TypeErasedDefaultGeneratorProvider provided an object that is not Generator<\(T.self)>. \
                            This is either a bug in Mixbox or bug in another framework that used `TypeErasedDefaultGeneratorProvider` incorrectly. \
                            Type erasure is a hack that allows to downcast an object of `DefaultGeneratorProvider` (which is \
                            a protocol with associated type `Self`, in this case `Self` = `\(T.self)`) and call `typeErasedDefaultGenerator` \
                            which should call to `defaultGenerator`. In the end it is expected that `defaultGenerator` is called and object of \
                            type `Generator<T>` (`T` is `\(T.self)`) is returned.
                            """
                        )
                    }
                } else {
                    throw ErrorString("fallback was not defined for `\(T.self)` (it is not conforming `DefaultGeneratorProvider`)")
                }
            } catch let fallbackError {
                let message = "failed to resolve generator of type \(T.self): \(resolveError) or fallback to default generator: \(fallbackError)"

                throw ErrorString(message)
            }
        }
    }
}
