public protocol DependencyInjection: DependencyResolver, DependencyRegisterer {
    func bootstrap() throws
}
