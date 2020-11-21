extension Optional {
    func map<T>(
        default: @autoclosure () -> T,
        transform: (Wrapped) throws -> T)
        rethrows
        -> T
    {
        return try map(transform) ?? `default`()
    }
}
