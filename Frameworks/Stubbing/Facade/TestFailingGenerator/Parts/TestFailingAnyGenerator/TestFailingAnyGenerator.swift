public protocol TestFailingAnyGenerator {
    /// Example:
    ///
    /// ```
    /// $0.myArray = [
    ///     $0.generate()
    ///     $0.generate()
    /// ]
    /// ```
    func generate<T>(
        type: T.Type)
        -> T
}

extension TestFailingAnyGenerator {
    public func generate<T>() -> T {
        return generate(type: T.self)
    }
}
