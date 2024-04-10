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
            (view.accessibilityElements ?? []).lazy.map(extractElement(from:))
        )
    }

    private func extractElement(from accessibilityElement: Any) -> ViewHierarchyElement {
        let accessibilityIdentifier = extractString(from: accessibilityElement, key: "accessibilityIdentifier")
        let accessibilityLabel = extractString(from: accessibilityElement, key: "accessibilityLabel")
        let accessibilityValue = extractString(from: accessibilityElement, key: "accessibilityValue")
        let accessibilityElements = extractValue(from: accessibilityElement, key: "accessibilityElements") as? [Any] ?? []

        let traits = extractAccessibilityTraits(from: accessibilityElement)
        let frameRelativeToScreen = extractAccessibilityFrame(from: accessibilityElement)
        let customClass = String(describing: type(of: accessibilityElement))

        let elementType = elementType(for: accessibilityElement)
            ?? elementType(for: traits)
            ?? .other

        let children = accessibilityElements.lazy.map(extractElement(from:))

        return DTOViewHierarchyElement(
            frame: .zero,                                   // TODO
            frameRelativeToScreen: frameRelativeToScreen,
            customClass: customClass,
            elementType: elementType,
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
            children: RandomAccessCollectionOf<ViewHierarchyElement, Int>(children)
        )
    }

    private func elementType(for instance: Any) -> ViewHierarchyElementType? {
        switch instance {
        case is UICollectionView:
            return .collectionView

        case is UICollectionViewCell:
            return .cell

        case is UIScrollView:
            return .scrollView

        default:
            return nil
        }
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
