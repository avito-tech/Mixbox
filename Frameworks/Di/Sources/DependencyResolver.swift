public protocol DependencyResolver {
    func resolve<T>() throws -> T
}
