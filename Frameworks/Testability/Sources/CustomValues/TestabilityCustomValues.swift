#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)

public final class TestabilityCustomValues {
    public static let dummy = TestabilityCustomValues()
    
    @inline(__always)
    public func remove(key: String) {
    }
    
    @inline(__always)
    public subscript <T: Codable>(_ key: String) -> T? {
        get {
            return nil
        }
        set {
        }
    }
}

#else
    
public final class TestabilityCustomValues {
    public private(set) var dictionary = [String: String]()
    
    public init() {
    }
    
    public func remove(key: String) {
        return dictionary[key] = nil
    }
    
    public subscript <T: Codable>(_ key: String) -> T? {
        get {
            return dictionary[key].flatMap {
                GenericSerialization.deserialize(string: $0)
            }
        }
        set {
            dictionary[key] = GenericSerialization.serialize(value: newValue)
        }
    }
}

#endif
