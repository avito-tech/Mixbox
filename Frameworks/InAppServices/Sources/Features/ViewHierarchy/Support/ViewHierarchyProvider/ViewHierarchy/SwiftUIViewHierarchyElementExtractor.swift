#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxTestability
import MixboxFoundation
import MixboxIpcCommon

final class SwiftUIViewHierarchyElementExtractor {
    func extractAccessibilityElements(from view: UIView) -> RandomAccessCollectionOf<ViewHierarchyElement, Int> {
        RandomAccessCollectionOf(
            (view.accessibilityElements ?? []).lazy.compactMap(SwiftUIViewHierarchyElement.init)
        )
    }
}

private final class SwiftUIViewHierarchyElement: ViewHierarchyElement {
    private typealias AccessibilityTraitsMethod = @convention(c) (NSObject, Selector) -> UInt64
    private typealias AccessibilityFrameMethod = @convention(c) (NSObject, Selector) -> CGRect

    let uniqueIdentifier: String

    private let accessibilityElement: Any

    private var accessibilityTraits: UIAccessibilityTraits {
        guard let object = accessibilityElement as? NSObject else {
            return .none
        }

        let selector = NSSelectorFromString("accessibilityTraits")
        let methodImp = object.method(for: selector)
        let method = unsafeBitCast(methodImp, to: AccessibilityTraitsMethod.self)
        let traits = method(object, selector)
        return UIAccessibilityTraits(rawValue: traits)
    }

    private var accessibilityFrame: CGRect {
        guard let object = accessibilityElement as? NSObject else {
            return .zero
        }

        let selector = NSSelectorFromString("accessibilityFrame")
        let methodImp = object.method(for: selector)
        let method = unsafeBitCast(methodImp, to: AccessibilityFrameMethod.self)
        return method(object, selector)
    }

    init?(accessibilityElement: Any) {
        // This filter ensures that we don't visit views twice
        // because they are already handled by TestabilityElementViewHierarchyElement.
        guard !(accessibilityElement is UIView) else {
            return nil
        }

        self.accessibilityElement = accessibilityElement
        self.uniqueIdentifier = UUID().uuidString
    }

    var frame: OptionalAvailability<CGRect> {
        .unavailable
    }

    var frameRelativeToScreen: CGRect {
        accessibilityFrame
    }

    var customClass: String {
        String(describing: type(of: accessibilityElement))
    }

    var elementType: ViewHierarchyElementType {
        let traits = accessibilityTraits

        if traits.contains(.staticText) {
            return .staticText
        } else if traits.contains(.button) {
            return .button
        } else if traits.contains(.image) {
            return .image
        } else if #available(iOS 17.0, *), traits.contains(.toggleButton) {
            return .toggle
        } else if traits.contains(.link) {
            return .link
        } else {
            return .other
        }
    }

    var accessibilityIdentifier: String? {
        extractString(key: "accessibilityIdentifier")
    }

    var accessibilityLabel: String? {
        extractString(key: "accessibilityLabel")
    }

    var accessibilityValue: String? {
        extractString(key: "accessibilityValue")
    }

    var accessibilityPlaceholderValue: String? {
        nil
    }

    var text: String? {
        accessibilityLabel
    }

    var isDefinitelyHidden: Bool {
        // Hidden SwiftUI views are removed from hierarchy.
        false
    }

    var isEnabled: Bool {
        !accessibilityTraits.contains(.notEnabled)
    }

    var hasKeyboardFocus: Bool {
        // Seems like all views that can be first responders are UIKit views
        // so we can assume everything else cannot have keyboard focus.
        false
    }

    var customValues: [String: String] {
        guard
            let hint = extractString(key: "accessibilityHint"),
            let data = hint.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String: String]
        else {
            return [:]
        }

        return json
    }

    var children: RandomAccessCollectionOf<ViewHierarchyElement, Int> {
        let accessibilityElements = extractValue(key: "accessibilityElements") as? [Any] ?? []

        return RandomAccessCollectionOf(
            accessibilityElements.lazy.compactMap(SwiftUIViewHierarchyElement.init)
        )
    }

    // https://medium.com/swlh/calling-ios-and-macos-hidden-api-in-style-1a924f244ad1

    private func extractValue(key: String) -> Any? {
        let selector = NSSelectorFromString(key)
        let unmanaged = (accessibilityElement as AnyObject).perform(selector)
        return unmanaged?.takeUnretainedValue()
    }

    private func extractString(key: String) -> String? {
        extractValue(key: key) as? String
    }
}

#endif
