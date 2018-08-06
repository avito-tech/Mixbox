import Foundation

final class AccessibilityUniqueObjectMap {
    static let shared = AccessibilityUniqueObjectMap()
    
    private init() {}
    private let values: NSMapTable<NSString, NSObject> = NSMapTable.strongToWeakObjects()
    
    func register(object: AccessibilityUniqulyIdentifiable & NSObject) {
        values.setObject(object, forKey: object.uniqueIdentifier as NSString)
    }
    
    func locate(uniqueIdentifier: String) -> NSObject? {
        return values.object(forKey: uniqueIdentifier as NSString)
    }
}
