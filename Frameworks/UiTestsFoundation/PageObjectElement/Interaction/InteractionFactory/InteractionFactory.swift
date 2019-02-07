import XCTest
import MixboxTestsFoundation

// TODO: Make `minimalPercentageOfVisibleArea` customizable (from tests/from page object definitions).
//       Now it depends only on the type of a check (it is hardcoded per each check). For example
//       it is 100% for snapshot assertion, because we need all view to be visible.
public protocol InteractionFactory {
    func actionInteraction(
        specificImplementation: InteractionSpecificImplementation,
        settings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat)
        -> Interaction
    
    func checkForNotDisplayedInteraction(
        settings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat)
        -> Interaction
    
    func checkInteraction(
        specificImplementation: InteractionSpecificImplementation,
        settings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat)
        -> Interaction
}
