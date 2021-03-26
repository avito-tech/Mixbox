import MixboxTestsFoundation
import MixboxIpcCommon
import MixboxUiTestsFoundation
import XCTest

// Swift wrapper for private XCTest Obj-C class `XCElementSnapshot`
final class XcuiElementSnapshot: ElementSnapshot {
//    private let xcElementSnapshot: XCElementSnapshot
    
    init(_ xcElementSnapshot: Any) {
        fatalError()
//        self.xcElementSnapshot = xcElementSnapshot
    }
    
    var isEnabled: Bool {
        fatalError()
//        return xcElementSnapshot.enabled
    }
    
    var text: OptionalAvailability<String?> {
        if let enhancedAccessibilityLabel = enhancedAccessibilityLabel {
            return .available(enhancedAccessibilityLabel.text)
        } else {
            return .unavailable
        }
    }
    
    var isDefinitelyHidden: OptionalAvailability<Bool> {
        if let enhancedAccessibilityLabel = enhancedAccessibilityLabel {
            return .available(enhancedAccessibilityLabel.isDefinitelyHidden)
        } else {
            return .unavailable
        }
    }
    
    var uniqueIdentifier: OptionalAvailability<String> {
        if let enhancedAccessibilityLabel = enhancedAccessibilityLabel {
            return .available(enhancedAccessibilityLabel.uniqueIdentifier)
        } else {
            return .unavailable
        }
    }
    
    var customValues: OptionalAvailability<[String: String]> {
        if let enhancedAccessibilityLabel = enhancedAccessibilityLabel {
            return .available(enhancedAccessibilityLabel.customValues)
        } else {
            return .unavailable
        }
    }
    
    var hasKeyboardFocus: Bool {
        fatalError()
//        return xcElementSnapshot.hasKeyboardFocus
    }
    
    var elementType: ElementType? {
        fatalError()
//        return ElementType(rawValue: UInt(xcElementSnapshot.elementType.rawValue))
    }
    
    var accessibilityPlaceholderValue: String? {
        fatalError()
//        return EnhancedAccessibilityLabel.originalAccessibilityPlaceholderValue(
//            accessibilityPlaceholderValue: xcElementSnapshot.placeholderValue
//        )
    }
    
    var accessibilityLabel: String {
        fatalError()
//        if let enhancedAccessibilityLabel = enhancedAccessibilityLabel {
//            return enhancedAccessibilityLabel.originalAccessibilityLabel ?? ""
//        } else {
//            return xcElementSnapshot.label ?? ""
//        }
    }
    
    var accessibilityValue: Any? {
        fatalError()
//        if let enhancedAccessibilityLabel = enhancedAccessibilityLabel {
//            return enhancedAccessibilityLabel.accessibilityValue
//        } else {
//            return xcElementSnapshot.value ?? ""
//        }
    }
    
    var accessibilityIdentifier: String {
        fatalError()
//        return xcElementSnapshot.identifier ?? ""
    }
    
    var frameRelativeToScreen: CGRect {
        fatalError()
//        return xcElementSnapshot.frame
    }

    var children: [ElementSnapshot] {
        fatalError()
//        return xcElementSnapshot.children.compactMap { child in
//            (child as? XCElementSnapshot).flatMap { XcuiElementSnapshot($0) }
//        }
    }
    
    var parent: ElementSnapshot? {
        fatalError()
//        guard let parent = xcElementSnapshot.parent else {
//            return nil
//        }
//        return XcuiElementSnapshot(parent)
    }
    
    var uikitClass: String? {
        return additionalAttributes[5004 as NSObject] as? String
    }
    
    var customClass: String? {
        return additionalAttributes[5041 as NSObject] as? String
    }
    
    // MARK: - Private
    
    private var enhancedAccessibilityLabel: EnhancedAccessibilityLabel? {
        fatalError()
//        return EnhancedAccessibilityLabel.fromAccessibilityLabel(xcElementSnapshot.label)
    }
    
    private var additionalAttributes: [NSObject: Any]  {
        fatalError()
//        return (xcElementSnapshot.additionalAttributes as [NSObject: Any]?) ?? [:]
    }
    
    // MARK: -
    
    var debugDescription: String {
        var fields = [String]()
        if let elementType = elementType {
            fields.append("elementType: \(elementType)")
        }
        fields.append("additionalAttributes: \(additionalAttributes)")
        fields.append("uniqueIdentifier: \(uniqueIdentifier)")
        fields.append("accessibilityIdentifier: \(accessibilityIdentifier)")
        fields.append("accessibilityLabel: \(accessibilityLabel)")
        if let placeholderValue = accessibilityPlaceholderValue {
            fields.append("placeholderValue: \(placeholderValue)")
        }
        fields.append("isDefinitelyHidden: \(isDefinitelyHidden)")
        if let value = accessibilityValue {
            fields.append("value: \(value)")
        }
        fields.append("isEnabled: \(isEnabled)")
        // fields.append("isSelected: \(selected)")
//        if let pathDescription = xcElementSnapshot.pathDescription as String? {
//            fields.append("pathDescription: \(pathDescription)")
//        }
        return fields.joined(separator: "\n")
    }
}
