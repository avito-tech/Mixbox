extension Bool {
    func ifTrue<T>(
        body: () throws -> T)
        rethrows
        -> T?
    {
        return self
            ? try body()
            : nil
    }
    
    func ifFalse<T>(
        body: () throws -> T)
        rethrows
        -> T?
    {
        return self
            ? nil
            : try body()
    }
    
    func map<T>(
        true: @autoclosure () -> T,
        false: @autoclosure () -> T)
        -> T
    {
        return self
            ? `true`()
            : `false`()
    }
}
