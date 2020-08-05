import MixboxGenerators

final class ConstantAnyGenerator: AnyGenerator {
    private let constant: Any
    
    init<T>(_ constant: T) {
        self.constant = constant
    }
    
    func generate<T>() throws -> T {
        return try (constant as? T).unwrapOrThrow()
    }
}
