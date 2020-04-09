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
                if let type = T.self as? TypeErasedDefaultGeneratorProvider.Type {
                    let typeErasedGenerator = try type.typeErasedDefaultGenerator(dependencyResolver: dependencyResolver)
                    
                    if let generator = typeErasedGenerator as? Generator<T> {
                        return generator
                    } else {
                        throw ErrorString("FIXME")
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
