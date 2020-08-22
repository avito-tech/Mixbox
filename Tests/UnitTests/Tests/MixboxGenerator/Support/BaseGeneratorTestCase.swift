import MixboxDi
import MixboxBuiltinDi
import MixboxStubbing
import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation

class BaseGeneratorTestCase: TestCase {
    override func dependencyInjectionConfiguration() -> DependencyInjectionConfiguration {
        DependencyInjectionConfiguration(
            dependencyCollectionRegisterer: GeneratorTestsDependencies()
        )
    }
    
    override var reuseState: Bool {
        false
    }
    
    var generator: GeneratorFacade {
        return dependencies.resolve()
    }
}
