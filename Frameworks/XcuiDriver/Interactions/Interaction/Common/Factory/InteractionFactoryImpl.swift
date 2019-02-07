import MixboxUiTestsFoundation
import XCTest
import MixboxTestsFoundation

public final class InteractionFactoryImpl: InteractionFactory {
    private let elementFinder: ElementFinder
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let scrollingHintsProvider: ScrollingHintsProvider
    private let snapshotCaches: SnapshotCaches
    private let applicationProvider: ApplicationProvider
    private let applicationCoordinatesProvider: ApplicationCoordinatesProvider
    
    public init(
        elementFinder: ElementFinder,
        elementVisibilityChecker: ElementVisibilityChecker,
        scrollingHintsProvider: ScrollingHintsProvider,
        snapshotCaches: SnapshotCaches,
        applicationProvider: ApplicationProvider,
        applicationCoordinatesProvider: ApplicationCoordinatesProvider)
    {
        self.elementFinder = elementFinder
        self.elementVisibilityChecker = elementVisibilityChecker
        self.scrollingHintsProvider = scrollingHintsProvider
        self.snapshotCaches = snapshotCaches
        self.applicationProvider = applicationProvider
        self.applicationCoordinatesProvider = applicationCoordinatesProvider
    }
    
    public func actionInteraction(
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
            snapshotCaches: snapshotCaches,
            applicationProvider: applicationProvider,
            applicationCoordinatesProvider: applicationCoordinatesProvider
        )
    }
    
    public func checkForNotDisplayedInteraction(
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
            snapshotCaches: snapshotCaches,
            applicationProvider: applicationProvider,
            applicationCoordinatesProvider: applicationCoordinatesProvider
        )
    }
    
    public func checkInteraction(
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
            snapshotCaches: snapshotCaches,
            applicationProvider: applicationProvider,
            applicationCoordinatesProvider: applicationCoordinatesProvider
        )
    }
}
