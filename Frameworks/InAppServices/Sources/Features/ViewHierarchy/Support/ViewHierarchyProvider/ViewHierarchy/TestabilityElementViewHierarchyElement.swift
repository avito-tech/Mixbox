#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxTestability
import MixboxFoundation
import MixboxIpcCommon

open class TestabilityElementViewHierarchyElement: ViewHierarchyElement {
    private let testabilityElement: TestabilityElement
    private let floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    private let accessibilityUniqueObjectMap: AccessibilityUniqueObjectMap

    private let swiftUIViewHierarchyElementExtractor = SwiftUIViewHierarchyElementExtractor()

    public init(
        testabilityElement: TestabilityElement,
        floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher,
        accessibilityUniqueObjectMap: AccessibilityUniqueObjectMap
    ) {
        // TODO: Remove side-effects from init
        accessibilityUniqueObjectMap.register(element: testabilityElement)
        
        self.testabilityElement = testabilityElement
        self.floatValuesForSr5346Patcher = floatValuesForSr5346Patcher
        self.accessibilityUniqueObjectMap = accessibilityUniqueObjectMap
    }
    
    public var frame: CGRect {
        floatValuesForSr5346Patcher.patched(
            frame: testabilityElement.mb_testability_frame()
        )
    }
    
    public var frameRelativeToScreen: CGRect {
        floatValuesForSr5346Patcher.patched(
            frame: testabilityElement.mb_testability_frameRelativeToScreen()
        )
    }
    
    public var customClass: String {
        testabilityElement.mb_testability_customClass()
    }
    
    public var elementType: ViewHierarchyElementType {
        TestabilityElementTypeConverter.covertToViewHierarchyElementType(
            elementType: testabilityElement.mb_testability_elementType()
        )
    }
    
    public var accessibilityIdentifier: String? {
        testabilityElement.mb_testability_accessibilityIdentifier()
    }
    
    public var accessibilityLabel: String? {
        // TODO: Avoid using swizzled implementation and return originalAccessibilityLabel directly from view.
        EnhancedAccessibilityLabel.originalAccessibilityLabel(
            accessibilityLabel: testabilityElement.mb_testability_accessibilityLabel()
        )
    }
    
    public var accessibilityValue: String? {
        testabilityElement.mb_testability_accessibilityValue()
    }
    
    public var accessibilityPlaceholderValue: String? {
        // TODO: Avoid using EnhancedAccessibilityLabel
        EnhancedAccessibilityLabel.originalAccessibilityPlaceholderValue(
            accessibilityPlaceholderValue: testabilityElement.mb_testability_accessibilityPlaceholderValue()
        )
    }
    
    public var text: String? {
        testabilityElement.mb_testability_text()
    }
    
    public var uniqueIdentifier: String {
        testabilityElement.mb_testability_uniqueIdentifier()
    }
    
    public var isDefinitelyHidden: Bool {
        testabilityElement.mb_testability_isDefinitelyHidden()
    }
    
    public var isEnabled: Bool {
        testabilityElement.mb_testability_isEnabled()
    }
    
    public var hasKeyboardFocus: Bool {
        testabilityElement.mb_testability_hasKeyboardFocus()
    }
    
    public var customValues: [String: String] {
        testabilityElement.mb_testability_getSerializedCustomValues()
    }
    
    public var children: RandomAccessCollectionOf<ViewHierarchyElement, Int> {
        RandomAccessCollectionOf(
            testabilityElement.mb_testability_children().lazy.map { [floatValuesForSr5346Patcher, accessibilityUniqueObjectMap, swiftUIViewHierarchyElementExtractor] testabilityElement in
                if let view = testabilityElement as? UIView, let element = swiftUIViewHierarchyElementExtractor.extractViewHierarchyElement(from: view) {
                    return element
                } else {
                    return TestabilityElementViewHierarchyElement(
                        testabilityElement: testabilityElement,
                        floatValuesForSr5346Patcher: floatValuesForSr5346Patcher,
                        accessibilityUniqueObjectMap: accessibilityUniqueObjectMap
                    )
                }
            }
        )
    }
}

private final class SwiftUIViewHierarchyElementExtractor {
    private typealias AccessibilityTraitsMethod = @convention(c) (NSObject, Selector) -> UInt64
    private typealias AccessibilityFrameMethod = @convention(c) (NSObject, Selector) -> CGRect

    func extractViewHierarchyElement(from view: UIView) -> ViewHierarchyElement? {
        guard view.isHostingView else {
            return nil
        }

        return extract(from: view, window: view.window!)
    }

    private func extract(from view: UIView, window: UIWindow) -> ViewHierarchyElement {
        let accessibilityChildren = (view.accessibilityElements ?? []).compactMap(extract(from:))
        let viewChildren = view.subviews.map { extract(from: $0, window: window) }

        return DTOViewHierarchyElement(
            frame: view.frame,
            frameRelativeToScreen: view.convert(view.frame, to: window),
            customClass: String(describing: type(of: view)),
            elementType: .other,                            // TODO
            accessibilityIdentifier: view.accessibilityIdentifier,
            accessibilityLabel: view.accessibilityLabel,
            accessibilityValue: view.accessibilityValue,
            accessibilityPlaceholderValue: nil,             // TODO
            text: nil,                                      // TODO
            uniqueIdentifier: String(describing: ObjectIdentifier(view)),   // TODO
            isDefinitelyHidden: view.isHidden,
            isEnabled: true,
            hasKeyboardFocus: false,
            customValues: [:],                              // TODO
            children: RandomAccessCollectionOf<ViewHierarchyElement, Int>(accessibilityChildren + viewChildren)
        )
    }

    private func extract(from accessibilityElement: Any) -> ViewHierarchyElement? {
        let accessibilityIdentifier = extractString(from: accessibilityElement, key: "accessibilityIdentifier")
        let accessibilityLabel = extractString(from: accessibilityElement, key: "accessibilityLabel")
        let accessibilityValue = extractString(from: accessibilityElement, key: "accessibilityValue")

        let traits = extractAccessibilityTraits(from: accessibilityElement)
        let frameRelativeToScreen = extractAccessibilityFrame(from: accessibilityElement)

        return DTOViewHierarchyElement(
            frame: .zero,                                   // TODO
            frameRelativeToScreen: frameRelativeToScreen,
            customClass: "todo",                            // TODO
            elementType: .other,                            // TODO
            accessibilityIdentifier: accessibilityIdentifier,
            accessibilityLabel: accessibilityLabel,
            accessibilityValue: accessibilityValue,
            accessibilityPlaceholderValue: nil,             // TODO
            text: nil,                                      // TODO
            uniqueIdentifier: String(describing: ObjectIdentifier(accessibilityElement as AnyObject)),  // TODO
            isDefinitelyHidden: false,                      // TODO
            isEnabled: !traits.contains(.notEnabled),
            hasKeyboardFocus: false,                        // TODO
            customValues: [:],                              // TODO
            children: RandomAccessCollectionOf<ViewHierarchyElement, Int>([])   // TODO
        )
    }

    // https://medium.com/swlh/calling-ios-and-macos-hidden-api-in-style-1a924f244ad1

    private func extractValue(from object: Any, key: String) -> Any? {
        let selector = NSSelectorFromString(key)
        let unmanaged = (object as AnyObject).perform(selector)
        return unmanaged?.takeUnretainedValue()
    }

    private func extractString(from object: Any, key: String) -> String? {
        extractValue(from: object, key: key) as? String
    }

    private func extractAccessibilityTraits(from object: Any) -> UIAccessibilityTraits {
        let object = object as! NSObject
        let selector = NSSelectorFromString("accessibilityTraits")
        let methodImp = object.method(for: selector)
        let method = unsafeBitCast(methodImp, to: AccessibilityTraitsMethod.self)
        let traits = method(object, selector)
        return UIAccessibilityTraits(rawValue: traits)
    }

    private func extractAccessibilityFrame(from object: Any) -> CGRect {
        let object = object as! NSObject
        let selector = NSSelectorFromString("accessibilityFrame")
        let methodImp = object.method(for: selector)
        let method = unsafeBitCast(methodImp, to: AccessibilityFrameMethod.self)
        return method(object, selector)
    }
}

private final class DTOViewHierarchyElement: ViewHierarchyElement {
    let frame: CGRect
    let frameRelativeToScreen: CGRect
    let customClass: String
    let elementType: ViewHierarchyElementType
    let accessibilityIdentifier: String?
    let accessibilityLabel: String?
    let accessibilityValue: String?
    let accessibilityPlaceholderValue: String?
    let text: String?
    let uniqueIdentifier: String
    let isDefinitelyHidden: Bool
    let isEnabled: Bool
    let hasKeyboardFocus: Bool
    let customValues: [String: String]
    let children: RandomAccessCollectionOf<ViewHierarchyElement, Int>

    init(
        frame: CGRect,
        frameRelativeToScreen: CGRect,
        customClass: String,
        elementType: ViewHierarchyElementType,
        accessibilityIdentifier: String?,
        accessibilityLabel: String?,
        accessibilityValue: String?,
        accessibilityPlaceholderValue: String?,
        text: String?,
        uniqueIdentifier: String,
        isDefinitelyHidden: Bool,
        isEnabled: Bool,
        hasKeyboardFocus: Bool,
        customValues: [String: String],
        children: RandomAccessCollectionOf<ViewHierarchyElement, Int>
    ) {
        self.frame = frame
        self.frameRelativeToScreen = frameRelativeToScreen
        self.customClass = customClass
        self.elementType = elementType
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityValue = accessibilityValue
        self.accessibilityPlaceholderValue = accessibilityPlaceholderValue
        self.text = text
        self.uniqueIdentifier = uniqueIdentifier
        self.isDefinitelyHidden = isDefinitelyHidden
        self.isEnabled = isEnabled
        self.hasKeyboardFocus = hasKeyboardFocus
        self.customValues = customValues
        self.children = children
    }
}

extension UIView {
    fileprivate var isHostingView: Bool {
        String(describing: type(of: self)).starts(with: "_UIHostingView")
    }

    fileprivate var topSuperview: UIView {
        superview?.topSuperview ?? self
    }
}

#endif
