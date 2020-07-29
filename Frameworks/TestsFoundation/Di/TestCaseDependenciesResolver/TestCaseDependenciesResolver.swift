import MixboxDi
import Dip

public protocol TestCaseDependenciesResolver {
    func resolve<T>() -> T
}
