import MixboxFoundation

// PageObjectElement with all known functionality.
// 
// It is made for hiding implementation of XCUI/GreyBox tests.
// The protocol should be NEVER used in tests.
//
// Tests should use restricted version of it for every particular type of element:
// - InputElement
// - ButtonElement
// - etc
//
// E.g.: you don't want to type text in button, so you will use ButtonElement, which
// has no ability to type text.
//
// Note that PageObjectElement can actually "type text in button", because  typing in UI tests
// is just actions of a user (tapping on element, waiting for keyboard and tapping on letters),
// there is no connection between element type in tests and element type inside app (UIButton/UIView/etc).
//
// TODO: Rename. It is actually (XCUI/GreyBox) implementation independent interface for making page object elements
public protocol PageObjectElement {
    var settings: ElementSettings { get }
    var interactionPerformer: PageObjectElementInteractionPerformer { get }
    
    func with(settings: ElementSettings) -> PageObjectElement
}
