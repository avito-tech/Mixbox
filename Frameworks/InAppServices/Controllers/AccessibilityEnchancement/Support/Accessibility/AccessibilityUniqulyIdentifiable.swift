import Foundation

public protocol AccessibilityUniqulyIdentifiable: NSObjectProtocol {
    var uniqueIdentifier: String { get }
}

private var associatedAccessibilityUniqueIdentifier = "associatedAccessibilityUniqueIdentifier_D42F45C4"

@nonobjc extension NSObject: AccessibilityUniqulyIdentifiable {
    public var uniqueIdentifier: String {
        guard let value = objc_getAssociatedObject(self, &associatedAccessibilityUniqueIdentifier) as? String else {
            let newValue = UUID().uuidString
            objc_setAssociatedObject(self, &associatedAccessibilityUniqueIdentifier, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newValue
        }
        return value
    }
}
