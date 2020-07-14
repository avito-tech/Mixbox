import MixboxDi
import Dip
import MixboxTestsFoundation

public protocol TestCaseDependenciesResolver {
    func resolve<T>() -> T
}
