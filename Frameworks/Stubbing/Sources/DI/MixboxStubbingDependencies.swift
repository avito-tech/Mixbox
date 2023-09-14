import MixboxGenerators
import MixboxDi
import MixboxBuiltinDi
import CoreGraphics
import Foundation

public final class MixboxStubbingDependencies: DependencyCollectionRegisterer {
    public init() {
    }
    
    // swiftlint:disable:next function_body_length
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        di.register(type: Generator<Void>.self) { _ in
            Generator { () }
        }
        di.register(type: Generator<Bool>.self) { di in
            try RandomBoolGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: Generator<Float>.self) { di in
            try RandomFloatGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: Generator<CGFloat>.self) { di in
            try RandomFloatGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: Generator<Double>.self) { di in
            try RandomFloatGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: Generator<Int>.self) { di in
            try RandomIntegerGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: Generator<String>.self) { di in
            try RandomStringGenerator(
                randomNumberProvider: di.resolve(),
                lengthGenerator: RandomIntegerGenerator(
                    randomNumberProvider: try di.resolve(),
                    closedRange: 0...20
                )
            )
        }
        di.register(type: Generator<Int64>.self) { di in
            try RandomIntegerGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: Generator<UInt64>.self) { di in
            try RandomIntegerGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: Generator<URL>.self) { di in
            try RandomUrlGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: RandomNumberProvider.self) { _ in
            MersenneTwisterRandomNumberProvider(seed: 0)
        }
        di.register(type: ByFieldsGeneratorResolver.self) { di in
            ByFieldsGeneratorResolverImpl(dependencyResolver: di)
        }
        di.register(type: TestFailingGeneratorObserver.self) { _ in
            NoopTestFailingGeneratorObserver()
        }
        di.register(type: GeneratorFacade.self) { di in
            GeneratorFacadeImpl(
                parentDi: WeakDependencyResolver(dependencyResolver: di),
                testFailureRecorder: try di.resolve(),
                byFieldsGeneratorResolver: try di.resolve(),
                dependencyInjectionFactory: BuiltinDependencyInjectionFactory(),
                testFailingGeneratorObserver: try di.resolve()
            )
        }
        
        let dependencyInjectionFactory = BuiltinDependencyInjectionFactory()
        let generatorFacadeStubsDi = dependencyInjectionFactory.dependencyInjection()
        
        di.register(type: AnyGenerator.self) { di in
            AnyGeneratorImpl(
                dependencyResolver: CompoundDependencyResolver(
                    resolvers: [
                        generatorFacadeStubsDi,
                        di
                    ]
                ),
                byFieldsGeneratorResolver: try di.resolve()
            )
        }
        di.register(type: TestFailingAnyGenerator.self) { di in
            TestFailingAnyGeneratorImpl(
                anyGenerator: try di.resolve()
            )
        }
        di.register(type: DynamicLookupGeneratorFactory.self) { di in
            DynamicLookupGeneratorFactoryImpl(
                anyGenerator: try di.resolve(),
                byFieldsGeneratorResolver: try di.resolve()
            )
        }
        di.register(type: BaseTestFailingGeneratorDependenciesFactory.self) { di in
            BaseTestFailingGeneratorDependenciesFactoryImpl(
                anyGenerator: try di.resolve(),
                testFailureRecorder: try di.resolve()
            )
        }
        di.register(type: ConfiguredDynamicLookupGeneratorProvider.self) { di in
            ConfiguredDynamicLookupGeneratorProviderImpl(
                dynamicLookupGeneratorFactory: try di.resolve(),
                byFieldsGeneratorResolver: try di.resolve(),
                testFailureRecorder: try di.resolve(),
                baseTestFailingGeneratorDependenciesFactory: try di.resolve()
            )
        }
        di.register(type: TestFailingGeneratorObserver.self) { _ in
            NoopTestFailingGeneratorObserver()
        }
        di.register(type: GeneratorFacade.self) { di in
            let baseTestFailingGeneratorDependenciesFactory: BaseTestFailingGeneratorDependenciesFactory = try di.resolve()
            let configuredDynamicLookupGeneratorProvider: ConfiguredDynamicLookupGeneratorProvider = try di.resolve()
            
            return GeneratorFacadeImpl(
                stubsDi: generatorFacadeStubsDi,
                configuredDynamicLookupGeneratorProvider: configuredDynamicLookupGeneratorProvider,
                baseTestFailingGeneratorDependencies: baseTestFailingGeneratorDependenciesFactory.baseTestFailingGeneratorDependencies(
                    configuredDynamicLookupGeneratorProvider: try di.resolve(),
                    testFailingGeneratorObserver: try di.resolve()
                )
            )
        }
        di.register(type: DefaultGeneratorResolvingStrategy.self) { _ in
            .empty
        }
    }
}
