public final class TestabilityCustomValues {
    public static let dummy = TestabilityCustomValues()
    
    #if MIXBOX_ENABLE_IN_APP_SERVICES
    public private(set) var dictionary = [String: String]()
    #endif
    
    public init() {
    }
    
    public subscript <T: Codable>(_ key: String) -> T? {
        get {
            #if MIXBOX_ENABLE_IN_APP_SERVICES
            return dictionary[key].flatMap {
                GenericSerialization.deserialize(string: $0)
            }
            #else
            return nil
            #endif
        }
        set {
            #if MIXBOX_ENABLE_IN_APP_SERVICES
            dictionary[key] = GenericSerialization.serialize(value: newValue)
            #else
            #endif
        }
    }
}
