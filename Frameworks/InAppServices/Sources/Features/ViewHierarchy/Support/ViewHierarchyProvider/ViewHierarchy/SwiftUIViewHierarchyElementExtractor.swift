#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxTestability
import MixboxFoundation
import MixboxIpcCommon

final class SwiftUIViewHierarchyElementExtractor {
    private typealias AccessibilityTraitsMethod = @convention(c) (NSObject, Selector) -> UInt64
    private typealias AccessibilityFrameMethod = @convention(c) (NSObject, Selector) -> CGRect

    func extractAccessibilityElements(from view: UIView) -> RandomAccessCollectionOf<ViewHierarchyElement, Int> {
        RandomAccessCollectionOf(
            (view.accessibilityElements ?? []).lazy.compactMap {
                self.extractElement(from: $0)
            }
        )
    }

    private func extractElement(from accessibilityElement: Any) -> ViewHierarchyElement? {
        // This filter ensures that we don't visit views twice
        // because they are already handled by TestabilityElementViewHierarchyElement.
        guard !(accessibilityElement is UIView) else {
            return nil
        }

        let accessibilityIdentifier = extractString(from: accessibilityElement, key: "accessibilityIdentifier")
        let accessibilityLabel = extractString(from: accessibilityElement, key: "accessibilityLabel")
        let accessibilityHint = extractString(from: accessibilityElement, key: "accessibilityHint")
        let accessibilityValue = extractString(from: accessibilityElement, key: "accessibilityValue")
        let accessibilityElements = extractValue(from: accessibilityElement, key: "accessibilityElements") as? [Any] ?? []

        let traits = extractAccessibilityTraits(from: accessibilityElement)
        let frameRelativeToScreen = extractAccessibilityFrame(from: accessibilityElement)
        let customClass = String(describing: type(of: accessibilityElement))

        let elementType = elementType(for: traits) ?? .other

        let children = accessibilityElements.compactMap {
            self.extractElement(from: $0)
        }

        return DTOViewHierarchyElement(
            frame: .unavailable,
            frameRelativeToScreen: frameRelativeToScreen,
            customClass: customClass,
            elementType: elementType,
            accessibilityIdentifier: accessibilityIdentifier,
            accessibilityLabel: accessibilityLabel,
            accessibilityValue: accessibilityValue,
            accessibilityPlaceholderValue: nil,             // TODO
            text: accessibilityLabel,
            uniqueIdentifier: UUID().uuidString,
            isDefinitelyHidden: false,
            isEnabled: !traits.contains(.notEnabled),
            hasKeyboardFocus: false,    // Seems like all views that can be first responders are UIKit views
                                        // so we can assume everything else cannot have keyboard focus.
            customValues: customValues(fromHint: accessibilityHint),
            children: RandomAccessCollectionOf(children)
        )
    }

    private func elementType(for traits: UIAccessibilityTraits) -> ViewHierarchyElementType? {
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
            return nil
        }
    }

    private func customValues(fromHint hint: String?) -> [String: String] {
        guard 
            let hint,
            let data = hint.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String: String]
        else {
            return [:]
        }

        return json
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

#endif
