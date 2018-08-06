import EarlGrey
import MixboxUiTestsFoundation

protocol PredicateNodeToEarlGreyMatcherConverter: class {
    func greyMatcher(predicateNode: PredicateNode) -> GREYMatcher
}

final class PredicateNodeToEarlGreyMatcherConverterImpl:
    PredicateNodeToEarlGreyMatcherConverter
{
    func greyMatcher(predicateNode: PredicateNode) -> GREYMatcher {
        switch predicateNode {
        case .and(let predicateNodes):
            return grey_allOf(predicateNodes.map(greyMatcher))
            
        case .or(let predicateNodes):
            return grey_anyOf(predicateNodes.map(greyMatcher))
            
        case .not(let predicateNode):
            return grey_not(greyMatcher(predicateNode: predicateNode))
            
        case .alwaysTrue:
            return grey_anything()
            
        case .alwaysFalse:
            return grey_not(grey_anything())
            
        case .accessibilityLabel(let value):
            return EarlGreyMatchers.accessibilityLabel(value)
            
        case .accessibilityValue(let value):
            return EarlGreyMatchers.accessibilityValue(value)
            
        case .accessibilityPlaceholderValue(let value):
            assertionFailure("Not implemented")
            return grey_not(grey_anything())
            
        case .accessibilityId(let value):
            return EarlGreyMatchers.accessibilityId(value)
            
        case .visibleText(let value):
            return EarlGreyMatchers.hasText(value)
            
        case .type(let value):
            return EarlGreyMatchers.type(value)
            
        case .isInstanceOf(let value):
            return EarlGreyMatchers.isInstanceOf(value)
            
        case .isSubviewOf(let value):
            return EarlGreyMatchers.isSubviewOf(greyMatcher(predicateNode: value))
        }
        
        // NOT IMPLEMENTED YET:
        
        // grey_keyWindow()
        // grey_accessibilityTrait(_ traits: UIAccessibilityTraits)
        // grey_accessibilityFocused()
        // grey_accessibilityHint(_ hint: String)
        // grey_text(_ inputText: String)
        // grey_firstResponder()
        // grey_systemAlertViewShown()
        // grey_minimumVisiblePercent(_ percent: CGFloat)
        // grey_sufficientlyVisible()
        // grey_interactable()
        // grey_notVisible()
        // grey_accessibilityElement()
        // grey_progress(_ comparisonMatcher: GREYMatcher)
        // grey_respondsToSelector(_ sel: Selector)
        // grey_conformsToProtocol(_ protocol: Protocol)
        // grey_descendant(_ descendantMatcher: GREYMatcher)
        // grey_buttonTitle(_ text: String)
        // grey_scrollViewContentOffset(_ offset: CGPoint)
        // grey_stepperValue(_ value: Double)
        // grey_sliderValueMatcher(_ valueMatcher: GREYMatcher)
        // grey_pickerColumnSetToValue(_ column: Int, _ value: String)
        // grey_datePickerValue(_ date: Date)
        // grey_enabled()
        // grey_selected()
        // grey_userInteractionEnabled()
        // grey_layout(_ constraints: [Any], _ referenceElementMatcher: GREYMatcher)
        // grey_nil()
        // grey_notNil()
        // grey_switchWithOnState(_ on: Bool)
        // grey_closeTo(_ value: Double, _ delta: Double)
        // grey_anything()
        // grey_equalTo(_ value: Any)
        // grey_lessThan(_ value: Any)
        // grey_greaterThan(_ value: Any)
        // grey_scrolledToContentEdge(_ edge: GREYContentEdge)
        //
    }
}
