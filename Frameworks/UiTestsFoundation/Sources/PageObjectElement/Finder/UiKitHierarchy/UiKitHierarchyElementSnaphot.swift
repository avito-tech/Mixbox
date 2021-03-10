import MixboxIpcCommon
import XCTest

final class UiKitHierarchyElementSnaphot: ElementSnapshot {
    private let data: ViewHierarchyElement
    
    private(set) var parent: ElementSnapshot?
    
    init(element: ViewHierarchyElement, parent: ElementSnapshot?) {
        self.parent = parent
        self.data = element
    }
    
    var isEnabled: Bool {
        return data.isEnabled
    }
    
    var text: OptionalAvailability<String?> {
        return .available(data.text)
    }
    
    var isDefinitelyHidden: OptionalAvailability<Bool> {
        return .available(data.isDefinitelyHidden)
    }
    
    var uniqueIdentifier: OptionalAvailability<String> {
        return .available(data.uniqueIdentifier)
    }
    
    var customValues: OptionalAvailability<[String: String]> {
        return .available(data.customValues)
    }
    
    var hasKeyboardFocus: Bool {
        return data.hasKeyboardFocus
    }
    
    var elementType: ElementType? {
        return ElementType(rawValue: UInt(data.elementType.rawValue))
    }
    
    var accessibilityPlaceholderValue: String? {
        return data.accessibilityPlaceholderValue
    }
    
    var accessibilityLabel: String {
        return data.accessibilityLabel ?? "" // TODO: Check if "" is a default value in XCUI
    }
    
    var accessibilityValue: Any? {
        return data.accessibilityValue
    }
    
    var accessibilityIdentifier: String {
        return data.accessibilityIdentifier ?? "" // TODO: Check if "" is a default value in XCUI
    }
    
    var frameRelativeToScreen: CGRect {
        return data.frameRelativeToScreen
    }
    
    var children: [ElementSnapshot] {
        return data.children.map { child in
            UiKitHierarchyElementSnaphot(
                element: child,
                parent: self
            )
        }
    }
    
    var uikitClass: String? {
        return nil
    }
    
    var customClass: String? {
        return data.customClass
    }
}
