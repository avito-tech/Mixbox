import MixboxUiTestsFoundation
import XCTest
import MixboxTestsFoundation

// TODO: Make `minimalPercentageOfVisibleArea` customizable (from tests/from page object definitions).
//       Now it depends only on the type of a check (it is hardcoded per each check). For example
//       it is 100% for snapshot assertion, because we need all view to be visible.
protocol InteractionFactory {
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

final class InteractionFactoryImpl: InteractionFactory {
    private let elementFinder: ElementFinder
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let scrollingHintsProvider: ScrollingHintsProvider
    private let snapshotCaches: SnapshotCaches
    
    init(
        elementFinder: ElementFinder,
        elementVisibilityChecker: ElementVisibilityChecker,
        scrollingHintsProvider: ScrollingHintsProvider,
        snapshotCaches: SnapshotCaches)
    {
        self.elementFinder = elementFinder
        self.elementVisibilityChecker = elementVisibilityChecker
        self.scrollingHintsProvider = scrollingHintsProvider
        self.snapshotCaches = snapshotCaches
    }
    
    func actionInteraction(
        specificImplementation: InteractionSpecificImplementation,
        settings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat)
        -> Interaction
    {
        return ActionInteraction(
            specificImplementation: specificImplementation,
            settings: settings,
            elementFinder: elementFinder,
            elementVisibilityChecker: elementVisibilityChecker,
            scrollingHintsProvider: scrollingHintsProvider,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            snapshotCaches: snapshotCaches
        )
    }
    
    func checkForNotDisplayedInteraction(
        settings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat)
        -> Interaction
    {
        return InvisibilityCheckInteraction(
            settings: settings,
            elementFinder: elementFinder,
            elementVisibilityChecker: elementVisibilityChecker,
            scrollingHintsProvider: scrollingHintsProvider,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            snapshotCaches: snapshotCaches
        )
    }
    
    func checkInteraction(
        specificImplementation: InteractionSpecificImplementation,
        settings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat)
        -> Interaction
    {
        return VisibleElementCheckInteraction(
            specificImplementation: specificImplementation,
            settings: settings,
            elementFinder: elementFinder,
            elementVisibilityChecker: elementVisibilityChecker,
            scrollingHintsProvider: scrollingHintsProvider,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            snapshotCaches: snapshotCaches
        )
    }
}
