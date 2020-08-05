import MixboxDi
import MixboxDipDi
import MixboxStubbing
import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import Dip

class BaseGeneratorTestCase: TestCase {
    private let staticDi = DipDependencyInjection(dependencyContainer: DependencyContainer())
    private let dynamicDi = DipDependencyInjection(dependencyContainer: DependencyContainer())
    
    var mocks: DependencyRegisterer {
        return dynamicDi
    }
    
    private(set) lazy var di = TestCaseDi.make(
        dependencyCollectionRegisterer: GeneratorTestsDependencies(),
        dependencyInjection: DependencyInjectionImpl(
            dependencyResolver: CompoundDependencyResolver(
                resolvers: [dynamicDi, staticDi]
            ),
            dependencyRegisterer: staticDi
        )
    )
    
    var generator: GeneratorFacade {
        return di.resolve()
    }
}
