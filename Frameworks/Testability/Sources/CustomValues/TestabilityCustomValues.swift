#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)

public final class TestabilityCustomValues {
    public static var dummy: TestabilityCustomValues {
        return TestabilityCustomValues()
    }
    
    @inline(__always)
    public func remove(key: String) {
    }
    
    @inline(__always)
    public subscript <T: Codable>(_ key: String) -> T? {
        get {
            return nil
        }
    }
}

#else
    
public final class TestabilityCustomValues {
    public private(set) var serializedDictionary: [String: String]
    
    public init(serializedDictionary: [String: String]) {
        self.serializedDictionary = serializedDictionary
    }
    
    public convenience init() {
        self.init(
            serializedDictionary: [:]
        )
    }
    
    public convenience init(_ other: TestabilityCustomValues) {
        self.init(
            serializedDictionary: other.serializedDictionary
        )
    }
    
    public func remove(key: String) {
        return serializedDictionary[key] = nil
    }
    
    public subscript <T: Codable>(_ key: String) -> T? {
        get {
            return serializedDictionary[key].flatMap {
                GenericSerialization.deserialize(string: $0)
            }
        }
        set {
            serializedDictionary[key] = GenericSerialization.serialize(value: newValue)
        }
    }
}

#endif
