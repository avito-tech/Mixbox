import MixboxDi

public protocol TestCaseDependenciesResolver {
    func resolve<T>() -> T
}
