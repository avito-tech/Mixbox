// PageObjectElement with all known functionality.
// 
// It is made for hiding implementation of EarlGrey and XCUI.
// The protocol is used in UITestsCore and should NEVER be used in tests.
//
// Tests should use restricted version of it for every particular type of element:
// - InputElement
// - ButtonElement
// - etc
//
// E.g.: you don't want to type text in button, so you will use ButtonElement, which
// has no ability to type text.
//
// Note that AlmightyElement can actually "type text in button", because  typing in UI tests
// is just actions of a user (tapping on element, waiting for keyboard and tapping on letters)
//
// TODO: AlmightyElement => ElementImplementation
public protocol AlmightyElement {
    var settings: ElementSettings { get }
    var actions: AlmightyElementActions { get }
    var checks: AlmightyElementChecks { get }
    var asserts: AlmightyElementChecks { get }
    var utils: AlmightyElementUtils { get }
    
    func with(settings: ElementSettings) -> AlmightyElement
    func withAssertsInsteadOfChecks() -> AlmightyElement
}

public protocol AlmightyElementActions {
    func tap(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    
    func press(
        duration: Double,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    
    func setText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    
    func swipe(
        direction: SwipeDirection,
        actionSettings: ActionSettings)
    
    func with(settings: ElementSettings) -> AlmightyElementActions
    
    // TODO: Remove/rewrite/repurpose (See issue #2)
    func typeText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    
    // TODO: Remove/rewrite/repurpose (See issue #2)
    func pasteText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    
    // TODO: Remove/rewrite/repurpose (See issue #2)
    func cutText(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    
    // TODO: Remove/rewrite/repurpose (See issue #2)
    func clearTextByTypingBackspaceMultipleTimes(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
}

public protocol AlmightyElementChecks {
    func checkText(checker: @escaping (String) -> (InteractionSpecificResult), checkSettings: CheckSettings) -> Bool
    func checkAccessibilityLabel(checker: @escaping (String) -> (InteractionSpecificResult), checkSettings: CheckSettings) -> Bool
    
    func hasValue(_ value: String, checkSettings: CheckSettings) -> Bool
    
    func hasHostDefinedValue(forKey key: String, referenceValue: String, checkSettings: CheckSettings, comparator: HostDefinedValueComparator) -> Bool
    
    func isNotDisplayed(checkSettings: CheckSettings) -> Bool
    func isDisplayed(checkSettings: CheckSettings) -> Bool
    func isInHierarchy(checkSettings: CheckSettings) -> Bool
    
    func becomesTallerAfter(action: @escaping () -> (), checkSettings: CheckSettings) -> Bool
    func becomesShorterAfter(action: @escaping () -> (), checkSettings: CheckSettings) -> Bool
    
    func isEnabled(checkSettings: CheckSettings) -> Bool
    func isDisabled(checkSettings: CheckSettings) -> Bool
    
    func hasImage(_ image: UIImage, checkSettings: CheckSettings) -> Bool
    func hasAnyImage(checkSettings: CheckSettings) -> Bool
    func hasNoImage(checkSettings: CheckSettings) -> Bool
    
    func isScrollable(checkSettings: CheckSettings) -> Bool
    
    func matchesReference(snapshot: String, checkSettings: CheckSettings) -> Bool
    func matchesReference(image: UIImage, checkSettings: CheckSettings) -> Bool
    
    func matches(
        checkSettings: CheckSettings,
        minimalPercentageOfVisibleArea: CGFloat,
        matcher: @escaping (ElementMatcherBuilder) -> ElementMatcher)
        -> Bool
    
    func with(settings: ElementSettings) -> AlmightyElementChecks
}

public protocol AlmightyElementUtils {
    func takeSnapshot(utilsSettings: UtilsSettings) -> UIImage?
    
    func with(settings: ElementSettings) -> AlmightyElementUtils
}
