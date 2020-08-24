import MixboxDi
import MixboxTestsFoundation
import MixboxGenerators

public class TestFailingDynamicLookupGenerator<GeneratedType: RepresentableByFields> {
    private let dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory
    private let byFieldsGeneratorResolver: ByFieldsGeneratorResolver
    private let testFailureRecorder: TestFailureRecorder
    private let testFailingGenerator: TestFailingGenerator
    
    public init(
        dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver,
        testFailureRecorder: TestFailureRecorder,
        testFailingGenerator: TestFailingGenerator)
    {
        self.dynamicLookupGeneratorFactory = dynamicLookupGeneratorFactory
        self.byFieldsGeneratorResolver = byFieldsGeneratorResolver
        self.testFailureRecorder = testFailureRecorder
        self.testFailingGenerator = testFailingGenerator
    }
    
    public func generate<T: RepresentableByFields>(
        type: T.Type = T.self,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T
    {
        generate(
            type: type,
            modifyConfigurator: { $0 },
            configure: configure
        )
    }
    
    public func generate<T>(
        type: T.Type = T.self)
        -> T
    {
        testFailingGenerator.generate()
    }
    
    public func generate<T: RepresentableByFields>(
        type: T.Type = T.self,
        index: Int,
        configure: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<T>) throws -> ())
        -> T
    {
        generate(
            type: type,
            modifyConfigurator: { $0.with(index: index) },
            configure: configure
        )
    }
    
    public func generateDictionary<K, V>(
        count expectedCount: Int,
        keyType: K.Type = K.self,
        valueType: V.Type = V.self,
        generateKey: (TestFailingDynamicLookupGenerator, Int) -> (K),
        generateValue: (TestFailingDynamicLookupGenerator, Int) -> (V))
        -> [K: V]
    {
        var dictionary = [K: V]()
        var attempt = 0
        let maxAttempts = expectedCount * 2
        
        while attempt < maxAttempts {
            attempt += 1
            
            let actualCount = dictionary.count
            
            if actualCount >= expectedCount {
                break
            }

            let key = generateKey(self, actualCount)
            let value = generateValue(self, actualCount)

            dictionary[key] = value
            
            let elementWasNotAdded = actualCount == dictionary.count
            if elementWasNotAdded {
                while attempt < maxAttempts, actualCount == dictionary.count {
                    attempt += 1
                    
                    let key = generateKey(self, actualCount)
                    
                    dictionary[key] = value
                }
            }
        }
        
        if dictionary.count == expectedCount {
            return dictionary
        } else if dictionary.count > expectedCount {
            testFailureRecorder.recordUnavoidableFailure(
                description:
                """
                Internal error. Generated \(dictionary.count) elements while only \(expectedCount) were requested.
                """
            )
        } else {
            testFailureRecorder.recordUnavoidableFailure(
                description:
                """
                Failed to generate Dictionary<\(K.self), \(V.self)> of \(expectedCount) elements. \
                Tried to generate unique keys \(maxAttempts) times, got \(dictionary.count) unique values: \(dictionary.keys). \
                Try to reduce count. For example, there are only 2 unique values for type `Bool`.
                """
            )
        }
    }
    
    // MARK: - Private
    
    private func generate<T: RepresentableByFields, MC>(
        type: T.Type = T.self,
        modifyConfigurator: (TestFailingDynamicLookupConfigurator<T>) throws -> MC,
        configure: @escaping (MC) throws -> ())
        -> T
    {
        do {
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
            
            try configure(
                modifyConfigurator(testFailingDynamicLookupConfigurator)
            )
            
            return try dynamicLookupGenerator.generate()
        } catch {
            testFailureRecorder.recordUnavoidableFailure(
                description:
                """
                Failed to generate \(T.self): \(error)
                """
            )
        }
    }
}
