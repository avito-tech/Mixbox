import MixboxBuiltinDi
import MixboxDi
import MixboxTestsFoundation
import MixboxGenerators

public final class GeneratorFacadeImpl: BaseTestFailingGenerator, GeneratorFacade {
    public let anyGenerator: AnyGenerator
    
    private let testFailingAnyGenerator: TestFailingAnyGenerator
    
    private let parentDi: DependencyResolver
    private let stubsDi: DependencyInjection
    private let dependencyResolver: DependencyResolver
    private let testFailureRecorder: TestFailureRecorder
    private let byFieldsGeneratorResolver: ByFieldsGeneratorResolver
    private let dependencyInjectionFactory: DependencyInjectionFactory
    private let configuredDynamicLookupGeneratorProvider: ConfiguredDynamicLookupGeneratorProvider
    
    public init(
        parentDi: DependencyResolver,
        testFailureRecorder: TestFailureRecorder,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver,
        dependencyInjectionFactory: DependencyInjectionFactory,
        testFailingGeneratorObserver: TestFailingGeneratorObserver)
    {
        self.parentDi = parentDi
        self.testFailureRecorder = testFailureRecorder
        self.byFieldsGeneratorResolver = byFieldsGeneratorResolver
        self.dependencyInjectionFactory = dependencyInjectionFactory
        
        stubsDi = dependencyInjectionFactory.dependencyInjection()
        
        dependencyResolver = CompoundDependencyResolver(
            resolvers: [
                stubsDi,
                parentDi
            ]
        )
        
        anyGenerator = AnyGeneratorImpl(
            dependencyResolver: dependencyResolver,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver
        )
        
        testFailingAnyGenerator = TestFailingAnyGeneratorImpl(
            anyGenerator: anyGenerator
        )
        
        let dynamicLookupGeneratorFactory = DynamicLookupGeneratorFactoryImpl(
            anyGenerator: anyGenerator,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver
        )
        
        let baseTestFailingGeneratorDependenciesFactory = BaseTestFailingGeneratorDependenciesFactoryImpl(
            anyGenerator: anyGenerator,
            testFailureRecorder: testFailureRecorder
        )
        
        configuredDynamicLookupGeneratorProvider = ConfiguredDynamicLookupGeneratorProviderImpl(
            dynamicLookupGeneratorFactory: dynamicLookupGeneratorFactory,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver,
            testFailureRecorder: testFailureRecorder,
            baseTestFailingGeneratorDependenciesFactory: baseTestFailingGeneratorDependenciesFactory
        )
        
        super.init(
            baseTestFailingGeneratorDependencies: baseTestFailingGeneratorDependenciesFactory.baseTestFailingGeneratorDependencies(
                configuredDynamicLookupGeneratorProvider: configuredDynamicLookupGeneratorProvider,
                testFailingGeneratorObserver: testFailingGeneratorObserver
            )
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
