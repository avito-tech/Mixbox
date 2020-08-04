import MixboxDi
import MixboxFoundation

public final class ByFieldsGeneratorResolverImpl: ByFieldsGeneratorResolver {
    private let dependencyResolver: DependencyResolver
    
    public init(dependencyResolver: DependencyResolver) {
        self.dependencyResolver = dependencyResolver
    }
    
    public func resolveByFieldsGenerator<T>() throws -> ByFieldsGenerator<T> {
        do {
            return try resolveViaDi()
        } catch let resolveViaDiError {
            do {
                return try resolveViaGeneratableByFields()
            } catch let resolveViaGeneratableByFieldsError {
                throw ErrorString(
                    """
                    Couldn't resolve `ByFieldsGenerator<\(T.self)>`: \
                    resolving directly via DI failed: \(resolveViaDiError) \
                    fallback by casting to GeneratableByFields failed: \(resolveViaGeneratableByFieldsError)
                    """
                )
            }
        }
    }
    
    private func resolveViaDi<T>() throws -> ByFieldsGenerator<T> {
        return try dependencyResolver.resolve() as ByFieldsGenerator<T>
    }
    
    private func resolveViaGeneratableByFields<T>() throws -> ByFieldsGenerator<T> {
        // The following hack will allow to generate object of type `T` automatically without
        // prior registration in DI. This will allow to get rid of a lot of boilerplate code in tests.
        if let type = T.self as? TypeErasedGeneratableByFields.Type {
            let typeErasedByFieldsGenerator = type.typeErasedByFieldsGenerator()
            
            if let generator = typeErasedByFieldsGenerator as? ByFieldsGenerator<T> {
                return generator
            } else {
                throw ErrorString(
                    """
                    TypeErasedGeneratableByFields provided an object that is not ByFieldsGenerator<\(T.self)>. \
                    This is either a bug in Mixbox or bug in another framework that used `TypeErasedGeneratableByFields` incorrectly. \
                    Type erasure is a hack that allows to downcast an object of `GeneratableByFields` (which is \
                    a protocol with associated type `Self`, in this case `Self` = `\(T.self)`) and call `typeErasedByFieldsGenerator` \
                    which should call to `byFieldsGenerator`. In the end it is expected that object of \
                    type `ByFieldsGenerator<T>` is returned (`T` is `\(T.self)`).
                    """
                )
            }
        } else {
            throw ErrorString(
                "Type \(T.self) doesn't conform to `TypeErasedGeneratableByFields` or `GeneratableByFields`"
            )
        }
    }
}
