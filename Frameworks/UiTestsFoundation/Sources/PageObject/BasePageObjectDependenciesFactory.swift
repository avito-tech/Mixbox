import MixboxDi
import MixboxTestsFoundation

open class BasePageObjectDependenciesFactory: PageObjectDependenciesFactory {
    public let di: TestFailingDependencyResolver
    
    public init(
        dependencyResolver parentDi: DependencyResolver,
        dependencyInjectionFactory: DependencyInjectionFactory,
        registerSpecificDependencies: (DependencyRegisterer) -> ())
    {
        let localDi = dependencyInjectionFactory.dependencyInjection()
        
        let compoundDi = DelegatingDependencyInjection(
            dependencyResolver: CompoundDependencyResolver(
                resolvers: [localDi, parentDi]
            ),
            dependencyRegisterer: localDi
        )
        
        localDi.register(type: ElementVisibilityChecker.self) { di in
            ElementVisibilityCheckerImpl(
                ipcClient: try di.resolve()
            )
        }
        localDi.register(type: ScrollingHintsProvider.self) { di in
            ScrollingHintsProviderImpl(
                ipcClient: try di.resolve()
            )
        }
        
        self.di = MixboxDiTestFailingDependencyResolver(dependencyResolver: compoundDi)
        
        registerSpecificDependencies(compoundDi)
    }
}
