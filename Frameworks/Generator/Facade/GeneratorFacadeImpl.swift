import MixboxDi
import Dip
import MixboxTestsFoundation

public final class GeneratorFacadeImpl: GeneratorFacade {
    private let anyGenerator: AnyGenerator
    private let testFailingGenerator: TestFailingGenerator
    private let parentDi: DependencyResolver
    private let stubsDi: DependencyInjection
    private let dependencyResolver: DependencyResolver
    private let testFailureRecorder: TestFailureRecorder
    private let byFieldsGeneratorResolver: ByFieldsGeneratorResolver
    
    public init(
        parentDi: DependencyResolver,
        testFailureRecorder: TestFailureRecorder,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver)
    {
        self.parentDi = parentDi
        self.testFailureRecorder = testFailureRecorder
        self.byFieldsGeneratorResolver = byFieldsGeneratorResolver
        
        // TODO: Use factory.
        stubsDi = DipDependencyInjection(dependencyContainer: DependencyContainer())
        
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
    
    public func stub<T>(
        configure: @escaping (TestFailingDynamicLookupGenerator<T>) throws -> ())
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
    
    public func generate<T>(
        configure: @escaping (TestFailingDynamicLookupGenerator<T>) throws -> ())
        -> T
    {
        let localDi = DipDependencyInjection(dependencyContainer: DependencyContainer())
        
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
    
    private func stub<T>(
        anyGenerator: AnyGenerator,
        dependencyRegisterer: DependencyRegisterer,
        dependencyResolver: DependencyResolver,
        configure: @escaping (TestFailingDynamicLookupGenerator<T>) throws -> ())
    {
        dependencyRegisterer.register(
            type: Generator<T>.self,
            factory: { [testFailureRecorder, byFieldsGeneratorResolver] _ in
                let dynamicLookupGeneratorFactory = DynamicLookupGeneratorFactoryImpl(
                    anyGenerator: anyGenerator,
                    byFieldsGeneratorResolver: byFieldsGeneratorResolver
                )
                
                let testFailingDynamicLookupGenerator = TestFailingDynamicLookupGenerator<T>(
                    dynamicLookupGenerator: try dynamicLookupGeneratorFactory.dynamicLookupGenerator(
                        byFieldsGeneratorResolver: byFieldsGeneratorResolver
                    ),
                    testFailureRecorder: testFailureRecorder
                )
                
                try configure(testFailingDynamicLookupGenerator)
                
                return testFailingDynamicLookupGenerator
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
