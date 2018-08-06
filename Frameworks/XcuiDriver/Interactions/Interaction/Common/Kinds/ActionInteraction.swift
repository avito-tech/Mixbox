import MixboxUiTestsFoundation
import MixboxTestsFoundation

// It is very similar to VisibleElementCheckInteraction. It seems like a copypaste,
// but it is only fields and constructor. But there's still a possibility to reduce amount of code.
// The code is shared in InteractionHelper. However InteractionHelper is bloated and needs to be split.
final class ActionInteraction: Interaction {
    let description: InteractionDescription
    let elementMatcher: ElementSnapshotMatcher
    
    private let settings: ResolvedInteractionSettings
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let scrollingHintsProvider: ScrollingHintsProvider
    private let elementFinder: ElementFinder
    private let specificImplementation: InteractionSpecificImplementation
    private let minimalPercentageOfVisibleArea: CGFloat
    
    private var wasSuccessful = false
    
    init(
        specificImplementation: InteractionSpecificImplementation,
        settings: ResolvedInteractionSettings,
        elementFinder: ElementFinder,
        elementVisibilityChecker: ElementVisibilityChecker,
        scrollingHintsProvider: ScrollingHintsProvider,
        minimalPercentageOfVisibleArea: CGFloat)
    {
        self.settings = settings
        self.description = InteractionDescription(
            type: .action,
            settings: settings
        )
        self.elementMatcher = ElementSnapshotMatchers.matcherForPredicate(
            settings.elementSettings.matcher.rootPredicateNode
        )
        self.specificImplementation = specificImplementation
        self.elementFinder = elementFinder
        self.elementVisibilityChecker = elementVisibilityChecker
        self.scrollingHintsProvider = scrollingHintsProvider
        self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
    }
    
    func perform() -> InteractionResult {
        if wasSuccessful {
            return .failure(
                InteractionFailureMaker.interactionFailure(message: "Attempted to run successful action twice")
            )
        }
        
        let helper = InteractionHelper(
            messagePrefix: "Действие неуспешно",
            elementVisibilityChecker: elementVisibilityChecker,
            scrollingHintsProvider: scrollingHintsProvider,
            elementFinder: elementFinder,
            interactionSettings: description.settings,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
        )
        
        return helper.retryInteractionUntilTimeout {
            let resolvedElementQuery = helper.resolveElementWithRetries()
            
            return helper.performInteractionForVisibleElement(
                resolvedElementQuery: resolvedElementQuery,
                interactionSpecificImplementation: specificImplementation,
                performingSpecificImplementationCanBeRepeated: true,
                closureFailureMessage: "пофейлилось само действие"
            )
        }
    }
}
