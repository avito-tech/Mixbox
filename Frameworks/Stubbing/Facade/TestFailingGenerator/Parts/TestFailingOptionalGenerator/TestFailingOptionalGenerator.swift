import MixboxGenerators

public protocol TestFailingOptionalGenerator {
    /// Example:
    ///
    /// ```
    /// $0.optional = $0.some()
    /// ```
    func some<T>(
        type: T.Type)
        -> T?
    
    /// Example:
    ///
    /// ```
    /// $0.optional = $0.some {
    ///     $0.int = 42
    /// }
    /// ```
    func some<T: RepresentableByFields>(
        type: T.Type,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T?
}

extension TestFailingOptionalGenerator {
    public func some<T>(
        type: T.Type = T.self)
        -> T?
    {
        return some(type: type)
    }
    
    public func some<T: RepresentableByFields>(
        type: T.Type = T.self,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T?
    {
        return some(type: type, configure: configure)
    }
}
