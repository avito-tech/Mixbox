import MixboxUiTestsFoundation
import MixboxTestsFoundation

final class VisibleElementCheckInteraction: Interaction {
    let description: InteractionDescription
    let elementMatcher: ElementMatcher
    
    private let settings: ResolvedInteractionSettings
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let scrollingHintsProvider: ScrollingHintsProvider
    private let elementFinder: ElementFinder
    private let specificImplementation: InteractionSpecificImplementation
    private let minimalPercentageOfVisibleArea: CGFloat
    private let snapshotCaches: SnapshotCaches
    
    init(
        specificImplementation: InteractionSpecificImplementation,
        settings: ResolvedInteractionSettings,
        elementFinder: ElementFinder,
        elementVisibilityChecker: ElementVisibilityChecker,
        scrollingHintsProvider: ScrollingHintsProvider,
        minimalPercentageOfVisibleArea: CGFloat,
        snapshotCaches: SnapshotCaches)
    {
        self.settings = settings
        self.description = InteractionDescription(
            type: .check,
            settings: settings
        )
        self.elementMatcher = settings.elementSettings.matcher
        self.elementFinder = elementFinder
        self.specificImplementation = specificImplementation
        self.elementVisibilityChecker = elementVisibilityChecker
        self.scrollingHintsProvider = scrollingHintsProvider
        self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
        self.snapshotCaches = snapshotCaches
    }
    
    func perform() -> InteractionResult {
        let helper = InteractionHelper(
            messagePrefix: "Проверка не прошла",
            elementVisibilityChecker: elementVisibilityChecker,
            scrollingHintsProvider: scrollingHintsProvider,
            elementFinder: elementFinder,
            interactionSettings: description.settings,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            snapshotCaches: snapshotCaches
        )
        
        return helper.retryInteractionUntilTimeout {
            let resolvedElementQuery = helper.resolveElementWithRetries()
            
            return helper.performInteractionForVisibleElement(
                resolvedElementQuery: resolvedElementQuery,
                interactionSpecificImplementation: specificImplementation,
                performingSpecificImplementationCanBeRepeated: false,
                closureFailureMessage: "пофейлилась сама проверка"
            )
        }
    }
}
