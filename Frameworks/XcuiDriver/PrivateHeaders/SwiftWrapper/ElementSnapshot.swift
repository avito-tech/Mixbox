import MixboxIpcCommon
import MixboxUiTestsFoundation

// TODO: Not public
public protocol ElementSnapshot: CustomDebugStringConvertible {
    // Кастомная инфа:
    var enhancedAccessibilityValue: EnhancedAccessibilityValue? { get }
    
    // Из XCElementSnapshot:
    var hasFocus: Bool { get }
    var hasKeyboardFocus: Bool { get }
    var isMainWindow: Bool { get }
    var isTopLevelTouchBarElement: Bool { get }
    var isTouchBarElement: Bool { get }
    var verticalSizeClass: XCUIElement.SizeClass { get }
    var horizontalSizeClass: XCUIElement.SizeClass { get }
    var selected: Bool { get } // TODO
    var enabled: Bool { get } // TODO
    var elementType: ElementType? { get }
    var placeholderValue: String? { get }
    var label: String { get }
    var title: String { get }
    var value: Any? { get }
    var identifier: String { get }
    var frame: CGRect { get }
    var visibleFrame: CGRect { get }
    
    var additionalAttributes: [NSObject: Any] { get } // TODO
    var userTestingAttributes: [Any] { get } // TODO
    var traits: UInt64 { get } // TODO (accessibility traits?)
    var children: [Any] { get } // TODO (XCElementSnapshot?)
    var parent: ElementSnapshot? { get }
    //var parentAccessibilityElement: AccessibilityElement? { get }
    //var accessibilityElement: AccessibilityElement? { get } // TODO: non-optional?
    var suggestedHitpoints: [Any] { get } // TODO
    var scrollView: ElementSnapshot? { get }
    
    var truncatedValueString: String? { get } // TODO
    var depth: Int64 { get } // TODO
    var pathFromRoot: ElementSnapshot? { get } // TODO
    var sparseTreeDescription: String? { get } // TODO
    var compactDescription: String? { get } // TODO
    var pathDescription: String? { get } // TODO}
    var recursiveDescriptionIncludingAccessibilityElement: String? { get } // TODO
    var recursiveDescription: String? { get } // TODO
    var identifiers: [Any] { get } // TODO
    var generation: UInt64 { get } // TODO
    var application: XCUIApplication? { get } // TODO: non-optional?
    
    func rootElement() -> ElementSnapshot?
}
