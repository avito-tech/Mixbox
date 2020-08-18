import MixboxDi
import MixboxGenerators
import MixboxStubbing
import MixboxTestsFoundation
import MixboxBuiltinDi

class GeneratorTestsDependencies: DependencyCollectionRegisterer {
    func register(dependencyRegisterer di: DependencyRegisterer) {
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
            try RandomStringGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: RandomNumberProvider.self) { _ in
            MersenneTwisterRandomNumberProvider(seed: 0)
        }
        di.register(type: TestFailureRecorder.self) { _ in
            XcTestFailureRecorder(
                currentTestCaseProvider: AutomaticCurrentTestCaseProvider(),
                shouldNeverContinueTestAfterFailure: false
            )
        }
        di.register(type: ByFieldsGeneratorResolver.self) { di in
            ByFieldsGeneratorResolverImpl(dependencyResolver: di)
        }
        di.register(type: GeneratorFacade.self) { di in
            GeneratorFacadeImpl(
                parentDi: WeakDependencyResolver(dependencyResolver: di),
                testFailureRecorder: try di.resolve(),
                byFieldsGeneratorResolver: try di.resolve(),
                dependencyInjectionFactory: BuiltinDependencyInjectionFactory()
            )
        }
        di.register(type: AnyGenerator.self) { di in
            (try di.resolve() as GeneratorFacade).anyGenerator
        }
    }
}
