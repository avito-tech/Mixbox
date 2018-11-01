import Foundation

private var testability_customValues_associatedObjectKey = "testabilityCusomValues_F46000692BA8"

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

extension NSObject {
    public var testability_customValues: TestabilityCustomValues {
        #if MIXBOX_ENABLE_IN_APP_SERVICES
        if let value = objc_getAssociatedObject(self, &testability_customValues_associatedObjectKey) as? TestabilityCustomValues {
            return value
        } else {
            let newValue = TestabilityCustomValues()
            objc_setAssociatedObject(
                self,
                &testability_customValues_associatedObjectKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            return newValue
        }
        #else
        return TestabilityCustomValues.dummy
        #endif
    }
}
