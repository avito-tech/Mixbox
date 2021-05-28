#if MIXBOX_ENABLE_IN_APP_SERVICES
    
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

#else

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

#endif
