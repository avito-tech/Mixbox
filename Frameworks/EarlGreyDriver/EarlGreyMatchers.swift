import EarlGrey
import MixboxUiTestsFoundation

// Shared between Locators and Checks (which are similar in EarlGrey).
// TODO: Maybe to merge Locators and Checks somehow.

final class EarlGreyMatchers {
    static func hasText(_ text: String) -> GREYMatcher {
        return checkText(
            checker: { elementText -> Bool in
                elementText == text
            }
        )
    }
    
    static func checkText(checker: @escaping (String) -> (Bool)) -> GREYMatcher {
        return grey_anyOf(
            [
                EarlGreyHelperMatchers.checkText(checker: checker),
                EarlGreyHelperMatchers.anySubviewCheckText(checker: checker) // TODO: - Not sure if it is necessary
            ]
        )
    }
    
    static func hasValue(_ value: String) -> GREYMatcher {
        return GREYElementMatcherBlock(
            matchesBlock: { (element: Any?) -> Bool in
                guard let object = element as? NSObject else {
                    return false
                }
                
                return object.accessibilityValue == value
            },
            descriptionBlock: { (description: Any) in
                if let greyDescription = description as? GREYDescription {
                    greyDescription.appendText("Имеет accessibilityValue = \(value)")
                }
            }
        )
    }
    
    static func isNotDisplayed() -> GREYMatcher {
        return grey_notVisible()
    }
    
    static func isDisplayed() -> GREYMatcher {
        return grey_sufficientlyVisible()
    }
    
    static func isEnabled() -> GREYMatcher {
        return grey_enabled()
    }
    
    static func isDisabled() -> GREYMatcher {
        return grey_not(grey_enabled())
    }
    
    static func accessibilityLabel(_ value: String) -> GREYMatcher {
        return grey_accessibilityLabel(value)
    }
    
    static func accessibilityValue(_ value: String) -> GREYMatcher {
        return grey_accessibilityValue(value)
    }
    
    static func accessibilityId(_ value: String) -> GREYMatcher {
        return grey_accessibilityID(value)
    }
    
    static func type(_ value: ElementType) -> GREYMatcher {
        return GREYElementMatcherBlock(
            matchesBlock: { (_: Any?) -> Bool in
                false
            },
            descriptionBlock: { (description: Any) in
                if let greyDescription = description as? GREYDescription {
                    greyDescription.appendText("Проверка на type не реализована для EarlGrey")
                }
            }
        )
    }
    
    static func isInstanceOf(_ value: AnyClass) -> GREYMatcher {
        return grey_kindOfClass(value)
    }
    
    static func isSubviewOf(_ matcher: GREYMatcher) -> GREYMatcher {
        return grey_ancestor(matcher)
    }
    
    static func hasImage(_ image: UIImage) -> GREYMatcher {
        return EarlGreyHelperMatchers.hasImage(image)
    }
    
    static func hasAnyImage() -> GREYMatcher {
        return EarlGreyHelperMatchers.hasAnyImage()
    }
    
    static func hasNoImage() -> GREYMatcher {
        return EarlGreyHelperMatchers.hasNoImage()
    }
    
    static func swipeToDirection(_ direction: SwipeDirection) -> GREYMatcher {
        return EarlGreyHelperMatchers.swipeToDirection(direction)
    }
    
    static func isScrollable() -> GREYMatcher {
        return EarlGreyHelperMatchers.isScrollViewSuitableForAutoScrolling()
    }
    
    static func matchesReference(snapshot: String, in folder: StaticString, utility: SnapshotsComparisonUtility) -> GREYMatcher {
        return EarlGreyHelperMatchers.matchesReference(snapshot: snapshot, in: folder, utility: utility)
    }
}
