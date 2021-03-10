import MixboxFoundation

// It is made for hiding implementation of blackbox/graybox testing mechanisms
// and providing rich functionality for make facades with nice interfaces that can be used
// for writing self-descriptive tests, like `button.tap()` or `input.type()`.
//
// The protocol should not be used in your tests. Use facades:
// - InputElement
// - ButtonElement
// - etc
//
// Or you can create your own elements with extended functionality.
//
public protocol PageObjectElementCore: class {
    var settings: ElementSettings { get }
    var interactionPerformer: PageObjectElementInteractionPerformer { get }
    
    func with(settings: ElementSettings) -> PageObjectElementCore
}
