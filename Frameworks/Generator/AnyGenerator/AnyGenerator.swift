public protocol AnyGenerator {
    func generate<T>() throws -> T
}
