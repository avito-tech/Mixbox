import MixboxGenerators

public protocol TestFailingArrayGenerator {
    /// Example:
    ///
    /// ```
    /// $0.myArray = $0.array(count: 1)
    /// ```
    func array<T>(
        count: Int,
        type: T.Type)
        -> [T]
    
    /// Example:
    ///
    /// ```
    /// $0.myArray = $0.array(count: 1) {
    ///     $0.int = 42
    /// }
    /// ```
    func array<T: RepresentableByFields>(
        count: Int,
        type: T.Type,
        configure: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<T>) throws -> ())
        -> [T]
}

extension TestFailingArrayGenerator {
    public func array<T>(
        count: Int,
        type: T.Type = T.self)
        -> [T]
    {
        return array(
            count: count,
            type: type
        )
    }
    
    public func array<T: RepresentableByFields>(
        count: Int,
        type: T.Type = T.self,
        configure: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<T>) throws -> ())
        -> [T]
    {
        return array(
            count: count,
            type: type,
            configure: configure
        )
    }
}
