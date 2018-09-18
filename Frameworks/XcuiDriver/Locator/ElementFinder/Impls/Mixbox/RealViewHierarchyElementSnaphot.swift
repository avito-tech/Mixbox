import MixboxIpcCommon
import MixboxUiTestsFoundation
import XCTest
import MixboxIpcCommon
import MixboxUiTestsFoundation

final class RealViewHierarchyElementSnaphot: ElementSnapshot {
    private let data: ViewHierarchyElement
    
    private(set) var parent: ElementSnapshot?
    
    init(element: ViewHierarchyElement, parent: ElementSnapshot?) {
        self.parent = parent
        self.data = element
    }
    
    var isEnabled: Bool {
        return data.isEnabled
    }
    
    var visibleText: OptionalAvailability<String?> {
        return .available(data.visibleText)
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
    
    var frameOnScreen: CGRect {
        var frame = data.frame
        
        if let parent = parent {
            frame = CGRect(
                x: frame.origin.x + parent.frameOnScreen.origin.x,
                y: frame.origin.y + parent.frameOnScreen.origin.y,
                width: frame.size.width,
                height: frame.size.height
            )
        }
        
        return frame
    }
    
    var children: [ElementSnapshot] {
        return data.children.map { child in
            RealViewHierarchyElementSnaphot(
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
