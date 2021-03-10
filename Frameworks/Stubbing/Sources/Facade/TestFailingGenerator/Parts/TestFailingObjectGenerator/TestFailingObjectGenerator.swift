import MixboxGenerators

public protocol TestFailingObjectGenerator {
    /// Example:
    ///
    /// ```
    /// $0.myArray = [
    ///     $0.generate { $0.int = 42 },
    ///     $0.generate { $0.int = 43 }
    /// ]
    /// ```
    func generate<T: RepresentableByFields>(
        type: T.Type,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T
}

extension TestFailingObjectGenerator {
    public func generate<T: RepresentableByFields>(
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T
    {
        return generate(type: T.self, configure: configure)
    }
}
