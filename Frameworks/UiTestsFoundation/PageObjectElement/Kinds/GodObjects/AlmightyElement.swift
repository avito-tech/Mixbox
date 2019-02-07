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
    
    func with(settings: ElementSettings) -> AlmightyElement
    func withAssertsInsteadOfChecks() -> AlmightyElement
}
