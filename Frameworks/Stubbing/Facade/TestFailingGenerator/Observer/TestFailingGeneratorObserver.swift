public protocol TestFailingGeneratorObserver {
    // Note: `type` can not be calculated via `value`
    // Example: `type` is `Animal.self`, `value` is `Cat()`.
    func didGenerate(type: Any.Type, value: Any)
}

extension TestFailingGeneratorObserver {
    public func observe<T>(
        type: T.Type = T.self,
        body: () -> T)
        -> T
    {
        let value = body()
        didGenerate(type: type, value: value)
        return value
    }
}
