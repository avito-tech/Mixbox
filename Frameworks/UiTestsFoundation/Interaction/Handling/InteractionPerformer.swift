// This protocol is intended to perform interactions with elements (actions, checks)
//
// The implementation can sophisticate interactions, e.g. can scroll to element
// before interaction - it is very handy not to write scrolling in each test,
// also if element was on the screen for a few versions of the app, but
// was shifted down later, tests will not be broken (because they will scroll
// the screen and find that element)
//
// What we get using this abstraction is simplifying code of tests.
//
// Also we may be using different InteractionPerformer`s for different situations
// (e.g. if we can't simply scroll the scroll view on a particular screen). But at the
// time this protocol was made it wasn't the case.

public protocol InteractionPerformer: class {
    @discardableResult
    func performInteraction(
        interaction: Interaction)
        -> InteractionResult
}

public final class InteractionPerformerImpl: InteractionPerformer {
    public init() {
    }
    
    @discardableResult
    public func performInteraction(interaction: Interaction) -> InteractionResult {
        return interaction.perform()
    }
}
