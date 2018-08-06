import Foundation

private var testabilityCustomValues_associatedObjectKey = "testabilityCusomValues_F46000692BA8"

extension NSObject {
    public var testabilityCustomValues: [String: String] {
        get {
            #if TEST
            if let value = objc_getAssociatedObject(self, &testabilityCustomValues_associatedObjectKey) as? [String: String] {
                return value
            } else {
                let newValue = [String: String]()
                objc_setAssociatedObject(
                    self,
                    &testabilityCustomValues_associatedObjectKey,
                    newValue,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
                return newValue
            }
            #else
            return [:]
            #endif
        }
        set {
            #if TEST
            objc_setAssociatedObject(
                self,
                &testabilityCustomValues_associatedObjectKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            #endif
        }
    }
}
