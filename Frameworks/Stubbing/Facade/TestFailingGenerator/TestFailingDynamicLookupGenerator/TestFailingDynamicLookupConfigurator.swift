import MixboxDi
import MixboxTestsFoundation
import MixboxGenerators

// Note: Avoid adding functions here. Every function can collide with dynamic member.
//       However, I think if we use function with same name everywhere it will negatively
//       impact performance or make compilation errors harder to debug.
@dynamicMemberLookup
public class TestFailingDynamicLookupConfigurator<GeneratedType: RepresentableByFields> {
    /// Used to resolve naming collisions.
    ///
    /// Example:
    ///
    /// ```
    /// // Not working:
    /// // $0.dictionary = $0.dictionary(count: 1)
    ///
    /// // Working:
    /// // $0.fields.dictionary = $0.dictionary(count: 1)
    /// ```
    public let fields: TestFailingDynamicLookupFields<GeneratedType>
    
    private let testFailingDynamicLookupGenerator: TestFailingDynamicLookupGenerator<GeneratedType>
    
    public init(
        testFailingDynamicLookupFields: TestFailingDynamicLookupFields<GeneratedType>,
        testFailingDynamicLookupGenerator: TestFailingDynamicLookupGenerator<GeneratedType>)
    {
        self.fields = testFailingDynamicLookupFields
        self.testFailingDynamicLookupGenerator = testFailingDynamicLookupGenerator
    }
    
    /// Example:
    ///
    /// ```
    /// $0.int = 42
    /// ```
    public subscript<FieldType>(
        dynamicMember keyPath: KeyPath<GeneratedType, FieldType>)
        -> FieldType
    {
        get {
            fields[dynamicMember: keyPath]
        }
        set {
            fields[dynamicMember: keyPath] = newValue
        }
    }
    
    /// Example:
    ///
    /// ```
    /// $0.myArray = [
    ///     $0.generate { $0.int = 42 },
    ///     $0.generate { $0.int = 43 }
    /// ]
    /// ```
    public func generate<T: RepresentableByFields>(
        type: T.Type = T.self,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T
    {
        return testFailingDynamicLookupGenerator.generate(
            type: type,
            configure: configure
        )
    }
    
    /// Example:
    ///
    /// ```
    /// $0.myArray = [
    ///     $0.generate()
    ///     $0.generate()
    /// ]
    /// ```
    public func generate<T>(
        type: T.Type = T.self)
        -> T
    {
        return testFailingDynamicLookupGenerator.generate(
            type: type
        )
    }
    
    /// Example:
    ///
    /// ```
    /// $0.optional = $0.some()
    /// ```
    public func some<T>(
        type: T.Type = T.self)
        -> T?
    {
        return generate(type: T.self)
    }
    
    /// Example:
    ///
    /// ```
    /// $0.optional = $0.some {
    ///     $0.int = 42
    /// }
    /// ```
    public func some<T: RepresentableByFields>(
        type: T.Type = T.self,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T?
    {
        return testFailingDynamicLookupGenerator.generate(
            type: type,
            configure: configure
        )
    }
    
    /// Example:
    ///
    /// ```
    /// $0.myArray = $0.array(count: 1)
    /// ```
    public func array<T>(
        count: Int,
        type: T.Type = T.self)
        -> [T]
    {
        return (0..<count).map { _ in
            testFailingDynamicLookupGenerator.generate(type: type)
        }
    }
    
    /// Example:
    ///
    /// ```
    /// $0.myArray = $0.array(count: 1) {
    ///     $0.int = 42
    /// }
    /// ```
    public func array<T: RepresentableByFields>(
        count: Int,
        type: T.Type = T.self,
        configure: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<T>) throws -> ())
        -> [T]
    {
        return (0..<count).map { index in
            testFailingDynamicLookupGenerator.generate(
                type: type,
                index: index,
                configure: configure
            )
        }
    }
    
    /// Example:
    ///
    /// ```
    /// $0.myDictionary = $0.dictionary(count: 1)
    /// ```
    public func dictionary<K, V>(
        count: Int,
        keyType: K.Type = K.self,
        valueType: V.Type = V.self)
        -> [K: V]
    {
        return testFailingDynamicLookupGenerator.generateDictionary(
            count: count,
            generateKey: { generator, _ in
                generator.generate(type: keyType)
            },
            generateValue: { generator, _ in
                generator.generate(type: valueType)
            }
        )
    }
    
    /// Example:
    ///
    /// ```
    /// $0.myDictionary = $0.dictionary(count: 1) {
    ///     $0.int = 42
    /// }
    /// ```
    public func dictionary<K: RepresentableByFields, V>(
        count: Int,
        keyType: K.Type = K.self,
        valueType: V.Type = V.self,
        keys: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<K>) throws -> ())
        -> [K: V]
    {
        return testFailingDynamicLookupGenerator.generateDictionary(
            count: count,
            generateKey: { generator, index in
                generator.generate(type: keyType, index: index, configure: keys)
            },
            generateValue: { generator, _ in
                generator.generate(type: valueType)
            }
        )
    }
    
    /// Example:
    ///
    /// ```
    /// $0.myDictionary = $0.dictionary(count: 1) {
    ///     $0.int = 42
    /// }
    /// ```
    public func dictionary<K, V: RepresentableByFields>(
        count: Int,
        keyType: K.Type = K.self,
        valueType: V.Type = V.self,
        values: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<V>) throws -> ())
        -> [K: V]
    {
        return testFailingDynamicLookupGenerator.generateDictionary(
            count: count,
            generateKey: { generator, _ in
                generator.generate(type: keyType)
            },
            generateValue: { generator, index in
                generator.generate(type: valueType, index: index, configure: values)
            }
        )
    }
    
    /// Example:
    ///
    /// ```
    /// $0.myDictionary = $0.dictionary(
    ///     count: 1,
    ///     keys: {
    ///         $0.int = 42
    ///     },
    ///     values: {
    ///         $0.int = 42
    ///     }
    /// }
    /// ```
    public func dictionary<K: RepresentableByFields, V: RepresentableByFields>(
        count: Int,
        keyType: K.Type = K.self,
        valueType: V.Type = V.self,
        keys: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<K>) throws -> (),
        values: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<V>) throws -> ())
        -> [K: V]
    {
        testFailingDynamicLookupGenerator.generateDictionary(
            count: count,
            generateKey: { generator, index in
                generator.generate(type: keyType, index: index, configure: keys)
            },
            generateValue: { generator, index in
                generator.generate(type: valueType, index: index, configure: values)
            }
        )
    }
}

// Internal
extension TestFailingDynamicLookupConfigurator {
    func with(index: Int) -> TestFailingDynamicLookupConfiguratorWithIndex<GeneratedType> {
        return TestFailingDynamicLookupConfiguratorWithIndex<GeneratedType>(
            testFailingDynamicLookupFields: fields,
            testFailingDynamicLookupGenerator: testFailingDynamicLookupGenerator,
            index: index
        )
    }
}
