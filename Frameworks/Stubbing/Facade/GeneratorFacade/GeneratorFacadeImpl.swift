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
    
    public convenience init(
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
        
        let testFailingAnyGenerator = TestFailingAnyGeneratorImpl(
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
        
        let configuredDynamicLookupGeneratorProvider = ConfiguredDynamicLookupGeneratorProviderImpl(
            dynamicLookupGeneratorFactory: dynamicLookupGeneratorFactory,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver,
            testFailureRecorder: testFailureRecorder,
            baseTestFailingGeneratorDependenciesFactory: baseTestFailingGeneratorDependenciesFactory
        )
        
        self.init(
            anyGenerator: anyGenerator,
            testFailingAnyGenerator: testFailingAnyGenerator,
            parentDi: parentDi,
            stubsDi: stubsDi,
            dependencyResolver: dependencyResolver,
            testFailureRecorder: testFailureRecorder,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver,
            dependencyInjectionFactory: dependencyInjectionFactory,
            configuredDynamicLookupGeneratorProvider: configuredDynamicLookupGeneratorProvider,
            baseTestFailingGeneratorDependencies: baseTestFailingGeneratorDependenciesFactory.baseTestFailingGeneratorDependencies(
                configuredDynamicLookupGeneratorProvider: configuredDynamicLookupGeneratorProvider,
                testFailingGeneratorObserver: testFailingGeneratorObserver
            )
        )
    }
    
    public init(
        anyGenerator: AnyGenerator,
        testFailingAnyGenerator: TestFailingAnyGenerator,
        parentDi: DependencyResolver,
        stubsDi: DependencyInjection,
        dependencyResolver: DependencyResolver,
        testFailureRecorder: TestFailureRecorder,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver,
        dependencyInjectionFactory: DependencyInjectionFactory,
        configuredDynamicLookupGeneratorProvider: ConfiguredDynamicLookupGeneratorProvider,
        baseTestFailingGeneratorDependencies: BaseTestFailingGeneratorDependencies)
    {
        self.anyGenerator = anyGenerator
        self.testFailingAnyGenerator = testFailingAnyGenerator
        self.parentDi = parentDi
        self.stubsDi = stubsDi
        self.dependencyResolver = dependencyResolver
        self.testFailureRecorder = testFailureRecorder
        self.byFieldsGeneratorResolver = byFieldsGeneratorResolver
        self.dependencyInjectionFactory = dependencyInjectionFactory
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
