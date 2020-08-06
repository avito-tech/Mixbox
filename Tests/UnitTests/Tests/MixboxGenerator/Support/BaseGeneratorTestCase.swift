import MixboxDi
import MixboxBuiltinDi
import MixboxStubbing
import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import Dip

class BaseGeneratorTestCase: TestCase {
    private let staticDi = BuiltinDependencyInjection()
    private let dynamicDi = BuiltinDependencyInjection()
    
    var mocks: DependencyRegisterer {
        return dynamicDi
    }
    
    private(set) lazy var di = TestCaseDi.make(
        dependencyCollectionRegisterer: GeneratorTestsDependencies(),
        dependencyInjection: DelegatingDependencyInjection(
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
