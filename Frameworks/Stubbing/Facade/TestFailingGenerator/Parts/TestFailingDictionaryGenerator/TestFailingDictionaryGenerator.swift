import MixboxGenerators

public protocol TestFailingDictionaryGenerator {
    /// Example:
    ///
    /// ```
    /// $0.myDictionary = $0.dictionary(count: 1)
    /// ```
    func dictionary<K, V>(
        count: Int,
        keyType: K.Type,
        valueType: V.Type)
        -> [K: V]
    
    /// Example:
    ///
    /// ```
    /// $0.myDictionary = $0.dictionary(count: 1) {
    ///     $0.int = 42
    /// }
    /// ```
    func dictionary<K: RepresentableByFields, V>(
        count: Int,
        keyType: K.Type,
        valueType: V.Type,
        keys: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<K>) throws -> ())
        -> [K: V]
    
    /// Example:
    ///
    /// ```
    /// $0.myDictionary = $0.dictionary(count: 1) {
    ///     $0.int = 42
    /// }
    /// ```
    func dictionary<K, V: RepresentableByFields>(
        count: Int,
        keyType: K.Type,
        valueType: V.Type,
        values: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<V>) throws -> ())
        -> [K: V]
    
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
    func dictionary<K: RepresentableByFields, V: RepresentableByFields>(
        count: Int,
        keyType: K.Type,
        valueType: V.Type,
        keys: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<K>) throws -> (),
        values: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<V>) throws -> ())
        -> [K: V]
}

extension TestFailingDictionaryGenerator {
    public func dictionary<K, V>(
        count: Int,
        keyType: K.Type = K.self,
        valueType: V.Type = V.self)
        -> [K: V]
    {
        dictionary(
            count: count,
            keyType: keyType,
            valueType: valueType
        )
    }
    
    public func dictionary<K: RepresentableByFields, V>(
        count: Int,
        keyType: K.Type = K.self,
        valueType: V.Type = V.self,
        keys: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<K>) throws -> ())
        -> [K: V]
    {
        dictionary(
            count: count,
            keyType: keyType,
            valueType: valueType,
            keys: keys
        )
    }
    
    public func dictionary<K, V: RepresentableByFields>(
        count: Int,
        keyType: K.Type = K.self,
        valueType: V.Type = V.self,
        values: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<V>) throws -> ())
        -> [K: V]
    {
        dictionary(
            count: count,
            keyType: keyType,
            valueType: valueType,
            values: values
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
        dictionary(
            count: count,
            keyType: keyType,
            valueType: valueType,
            keys: keys,
            values: values
        )
    }
}
