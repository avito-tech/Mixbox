import MixboxBuiltinDi
import MixboxDi
import MixboxTestsFoundation
import MixboxGenerators

public final class GeneratorFacadeImpl: BaseTestFailingGenerator, GeneratorFacade {
    private let stubsDi: DependencyInjection
    private let configuredDynamicLookupGeneratorProvider: ConfiguredDynamicLookupGeneratorProvider
    
    public convenience init(
        // DI that contain your dependencies, e.g. registered generators like Generator<Int>
        parentDi: DependencyResolver,
        testFailureRecorder: TestFailureRecorder,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver,
        dependencyInjectionFactory: DependencyInjectionFactory,
        testFailingGeneratorObserver: TestFailingGeneratorObserver)
    {
        let stubsDi = dependencyInjectionFactory.dependencyInjection()
        
        let dependencyResolver = CompoundDependencyResolver(
            resolvers: [
                stubsDi,
                parentDi
            ]
        )
        
        let anyGenerator = AnyGeneratorImpl(
            dependencyResolver: dependencyResolver,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver
        )
        
        let dynamicLookupGeneratorFactory = DynamicLookupGeneratorFactoryImpl(
            anyGenerator: anyGenerator,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver
        )
        
        let baseTestFailingGeneratorDependenciesFactory = BaseTestFailingGeneratorDependenciesFactoryImpl(
            anyGenerator: anyGenerator,
            testFailureRecorder: testFailureRecorder
        )
        
        let configuredDynamicLookupGeneratorProvider = ConfiguredDynamicLookupGeneratorProviderImpl(
            dynamicLookupGeneratorFactory: dynamicLookupGeneratorFactory,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver,
            testFailureRecorder: testFailureRecorder,
            baseTestFailingGeneratorDependenciesFactory: baseTestFailingGeneratorDependenciesFactory
        )
        
        self.init(
            stubsDi: stubsDi,
            configuredDynamicLookupGeneratorProvider: configuredDynamicLookupGeneratorProvider,
            baseTestFailingGeneratorDependencies: baseTestFailingGeneratorDependenciesFactory.baseTestFailingGeneratorDependencies(
                configuredDynamicLookupGeneratorProvider: configuredDynamicLookupGeneratorProvider,
                testFailingGeneratorObserver: testFailingGeneratorObserver
            )
        )
    }
    
    public init(
        stubsDi: DependencyInjection,
        configuredDynamicLookupGeneratorProvider: ConfiguredDynamicLookupGeneratorProvider,
        baseTestFailingGeneratorDependencies: BaseTestFailingGeneratorDependencies)
    {
        self.stubsDi = stubsDi
        self.configuredDynamicLookupGeneratorProvider = configuredDynamicLookupGeneratorProvider
        
        super.init(
            baseTestFailingGeneratorDependencies: baseTestFailingGeneratorDependencies
        )
    }
    
    public func stub<T: RepresentableByFields>(
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
    {
        stubsDi.register(
            type: Generator<T>.self,
            factory: { [configuredDynamicLookupGeneratorProvider] _ in
                try configuredDynamicLookupGeneratorProvider.configuredDynamicLookupGenerator(
                    type: T.self,
                    configure: configure
                )
            }
        )
    }
}
