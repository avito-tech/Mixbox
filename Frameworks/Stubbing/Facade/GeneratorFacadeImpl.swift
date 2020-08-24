import MixboxBuiltinDi
import MixboxDi
import MixboxTestsFoundation
import MixboxGenerators

public final class GeneratorFacadeImpl: GeneratorFacade {
    public let anyGenerator: AnyGenerator
    
    private let testFailingGenerator: TestFailingGenerator
    private let parentDi: DependencyResolver
    private let stubsDi: DependencyInjection
    private let dependencyResolver: DependencyResolver
    private let testFailureRecorder: TestFailureRecorder
    private let byFieldsGeneratorResolver: ByFieldsGeneratorResolver
    private let dependencyInjectionFactory: DependencyInjectionFactory
    
    public init(
        parentDi: DependencyResolver,
        testFailureRecorder: TestFailureRecorder,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver,
        dependencyInjectionFactory: DependencyInjectionFactory)
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
        
        testFailingGenerator = TestFailingGeneratorImpl(
            anyGenerator: anyGenerator
        )
    }
    
    public func stub<T: RepresentableByFields>(
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
    {
        stub(
            anyGenerator: anyGenerator,
            dependencyRegisterer: stubsDi,
            dependencyResolver: dependencyResolver,
            configure: configure
        )
    }
    
    public func generate<T>() -> T {
        return testFailingGenerator.generate()
    }
    
    public func generate<T: RepresentableByFields>(
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T
    {
        let localDi = dependencyInjectionFactory.dependencyInjection()
        
        let dependencyResolver = CompoundDependencyResolver(
            resolvers: [
                localDi,
                stubsDi,
                parentDi
            ]
        )
        
        let anyGenerator = AnyGeneratorImpl(
            dependencyResolver: dependencyResolver,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver
        )
        
        let testFailingGenerator = TestFailingGeneratorImpl(
            anyGenerator: anyGenerator
        )
        
        stub(
            anyGenerator: anyGenerator,
            dependencyRegisterer: localDi,
            dependencyResolver: dependencyResolver,
            configure: configure
        )
        
        return testFailingGenerator.generate()
    }
    
    private func stub<T: RepresentableByFields>(
        anyGenerator: AnyGenerator,
        dependencyRegisterer: DependencyRegisterer,
        dependencyResolver: DependencyResolver,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
    {
        dependencyRegisterer.register(
            type: Generator<T>.self,
            factory: { [testFailureRecorder, byFieldsGeneratorResolver, testFailingGenerator] _ in
                let dynamicLookupGeneratorFactory = DynamicLookupGeneratorFactoryImpl(
                    anyGenerator: anyGenerator,
                    byFieldsGeneratorResolver: byFieldsGeneratorResolver
                )
                
                let dynamicLookupGenerator: DynamicLookupGenerator<T> = try dynamicLookupGeneratorFactory.dynamicLookupGenerator(
                    byFieldsGeneratorResolver: byFieldsGeneratorResolver
                )
                
                let testFailingDynamicLookupConfigurator = TestFailingDynamicLookupConfigurator<T>(
                    testFailingDynamicLookupFields: TestFailingDynamicLookupFields<T>(
                        dynamicLookupGenerator: dynamicLookupGenerator,
                        testFailureRecorder: testFailureRecorder
                    ),
                    testFailingDynamicLookupGenerator: TestFailingDynamicLookupGenerator<T>(
                        dynamicLookupGeneratorFactory: dynamicLookupGeneratorFactory,
                        byFieldsGeneratorResolver: byFieldsGeneratorResolver,
                        testFailureRecorder: testFailureRecorder,
                        testFailingGenerator: testFailingGenerator
                    )
                )
                
                try configure(testFailingDynamicLookupConfigurator)
                
                return dynamicLookupGenerator
            }
        )
    }
    
    private static func anyGenerator(
        dependencyResolver: DependencyResolver,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver)
        -> TestFailingGenerator
    {
        return TestFailingGeneratorImpl(
            anyGenerator: AnyGeneratorImpl(
                dependencyResolver: dependencyResolver,
                byFieldsGeneratorResolver: byFieldsGeneratorResolver
            )
        )
    }
    
    private static func generator(
        dependencyResolver: DependencyResolver,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver)
        -> TestFailingGenerator
    {
        return TestFailingGeneratorImpl(
            anyGenerator: AnyGeneratorImpl(
                dependencyResolver: dependencyResolver,
                byFieldsGeneratorResolver: byFieldsGeneratorResolver
            )
        )
    }
}
