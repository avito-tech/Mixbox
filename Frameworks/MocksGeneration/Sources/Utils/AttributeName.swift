// Not a complete list of attributes.
// Docs: https://docs.swift.org/swift-book/ReferenceManual/Attributes.html
// Note that docs don't contain complete list of attributes either.
public enum AttributeName: String {
    // Declaration Attributes
    
    case available
    case discardableResult
    case dynamicCallable
    case dynamicMemberLookup
    case frozen
    case GKInspectable
    case inlinable
    case main
    case nonobjc
    case NSApplicationMain
    case NSCopying
    case NSManaged
    case objc
    case objcMembers
    case propertyWrapper
    case requires_stored_property_inits
    case testable
    case UIApplicationMain
    case usableFromInline
    case warn_unqualified_access
    case IBAction
    case IBSegueAction
    case IBOutlet
    case IBInspectable
    case IBDesignable
    
    // Type Attributes
    case autoclosure
    case convention
    case escaping
    
    // Switch Case Attributes
    case unknown
    
    public static let attributesNamesWithoutParenthesis: Set<AttributeName> = [
        .discardableResult,
        .dynamicCallable,
        .dynamicMemberLookup,
        .frozen,
        .GKInspectable,
        .inlinable,
        .main,
        .nonobjc,
        .NSApplicationMain,
        .NSCopying,
        .NSManaged,
        .objcMembers,
        .propertyWrapper,
        .requires_stored_property_inits,
        .testable,
        .UIApplicationMain,
        .usableFromInline,
        .warn_unqualified_access,
        .IBAction,
        .IBSegueAction,
        .IBOutlet,
        .IBInspectable,
        .IBDesignable,
        .autoclosure,
        .escaping,
        .unknown
    ]
    
    public static let attributesNamesWithoutParenthesisRawValues = Set<String>(
        attributesNamesWithoutParenthesis.map { $0.rawValue }
    )
    
    public static let attributesNamesWithParenthesis: Set<AttributeName> = [
        .available,
        .objc,
        .convention
    ]
    
    public static let attributesNamesWithParenthesisRawValues = Set<String>(
        attributesNamesWithParenthesis.map { $0.rawValue }
    )
}
