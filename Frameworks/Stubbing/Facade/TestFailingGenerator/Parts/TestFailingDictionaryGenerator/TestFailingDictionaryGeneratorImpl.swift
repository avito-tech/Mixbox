import MixboxGenerators
import MixboxTestsFoundation

public final class TestFailingDictionaryGeneratorImpl: TestFailingDictionaryGenerator {
    private let testFailingObjectGeneratorWithConfiguratorModification: TestFailingObjectGeneratorWithConfiguratorModification
    private let testFailingAnyGenerator: TestFailingAnyGenerator
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        testFailingObjectGeneratorWithConfiguratorModification: TestFailingObjectGeneratorWithConfiguratorModification,
        testFailingAnyGenerator: TestFailingAnyGenerator,
        testFailureRecorder: TestFailureRecorder)
    {
        self.testFailingObjectGeneratorWithConfiguratorModification = testFailingObjectGeneratorWithConfiguratorModification
        self.testFailingAnyGenerator = testFailingAnyGenerator
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func dictionary<K, V>(
        count: Int,
        keyType: K.Type,
        valueType: V.Type)
        -> [K: V]
    {
        return generateDictionary(
            count: count,
            generateKey: { _ in
                testFailingAnyGenerator.generate(
                    type: keyType
                )
            },
            generateValue: { _ in
                testFailingAnyGenerator.generate(
                    type: valueType
                )
            }
        )
    }
    
    public func dictionary<K: RepresentableByFields, V>(
        count: Int,
        keyType: K.Type,
        valueType: V.Type,
        keys: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<K>) throws -> ())
        -> [K: V]
    {
        return generateDictionary(
            count: count,
            generateKey: { index in
                testFailingObjectGeneratorWithConfiguratorModification.generate(
                    type: keyType,
                    index: index,
                    configure: keys
                )
            },
            generateValue: { _ in
                testFailingAnyGenerator.generate(
                    type: valueType
                )
            }
        )
    }
    
    public func dictionary<K, V: RepresentableByFields>(
        count: Int,
        keyType: K.Type,
        valueType: V.Type,
        values: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<V>) throws -> ())
        -> [K: V]
    {
        return generateDictionary(
            count: count,
            generateKey: { _ in
                testFailingAnyGenerator.generate(
                    type: keyType
                )
            },
            generateValue: { index in
                testFailingObjectGeneratorWithConfiguratorModification.generate(
                    type: valueType,
                    index: index,
                    configure: values
                )
            }
        )
    }
    
    public func dictionary<K: RepresentableByFields, V: RepresentableByFields>(
        count: Int,
        keyType: K.Type = K.self,
        valueType: V.Type = V.self,
        keys: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<K>) throws -> (),
        values: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<V>) throws -> ())
        -> [K: V]
    {
        return generateDictionary(
            count: count,
            generateKey: { index in
                testFailingObjectGeneratorWithConfiguratorModification.generate(
                    type: keyType,
                    index: index,
                    configure: keys
                )
            },
            generateValue: { index in
                testFailingObjectGeneratorWithConfiguratorModification.generate(
                    type: valueType,
                    index: index,
                    configure: values
                )
            }
        )
    }
    
    // MARK: - Private
    
    private func generateDictionary<K, V>(
        count expectedCount: Int,
        keyType: K.Type = K.self,
        valueType: V.Type = V.self,
        generateKey: (Int) -> (K),
        generateValue: (Int) -> (V))
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

            let key = generateKey(actualCount)
            let value = generateValue(actualCount)

            dictionary[key] = value
            
            let elementWasNotAdded = actualCount == dictionary.count
            if elementWasNotAdded {
                while attempt < maxAttempts, actualCount == dictionary.count {
                    attempt += 1
                    
                    let key = generateKey(actualCount)
                    
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
}
