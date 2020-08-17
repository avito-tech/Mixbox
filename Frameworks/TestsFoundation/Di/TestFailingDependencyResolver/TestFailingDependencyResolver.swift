import MixboxDi

public protocol TestFailingDependencyResolver {
    func resolve<T>() -> T
}
