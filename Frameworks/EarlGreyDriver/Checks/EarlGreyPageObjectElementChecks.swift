import MixboxUiTestsFoundation
import EarlGrey
import MixboxTestsFoundation

final class EarlGreyPageObjectElementChecks: AlmightyElementChecks {
    private let elementSettings: ElementSettings
    private let interactionPerformerFactory: InteractionPerformerFactory
    private let interactionFactory: InteractionFactory
    private let snapshotsComparisonUtility: SnapshotsComparisonUtility
    private let isAssertions: Bool
    
    init(
        elementSettings: ElementSettings,
        interactionPerformerFactory: InteractionPerformerFactory,
        interactionFactory: InteractionFactory,
        snapshotsComparisonUtility: SnapshotsComparisonUtility,
        isAssertions: Bool)
    {
        self.elementSettings = elementSettings
        self.interactionPerformerFactory = interactionPerformerFactory
        self.interactionFactory = interactionFactory
        self.snapshotsComparisonUtility = snapshotsComparisonUtility
        self.isAssertions = isAssertions
    }
    
    // MARK: - Private
    
    private func performCheck(
        checkMatcher: GREYMatcher,
        checkSettings: CheckSettings,
        isCheckForNotDisplayed: Bool = false)
         -> Bool
    {
        let interaction = interactionFactory.interaction(
            settings: ResolvedInteractionSettings(
                interactionSettings: checkSettings,
                elementSettings: elementSettings
            ),
            elementMatcher: elementSettings.matcher,
            checkMatcher: checkMatcher,
            isCheckForNotDisplayed: isCheckForNotDisplayed
        )
        
        let interactionPerformer = interactionPerformerFactory.performerForInteraction(
            isCheckForNotDisplayed: isCheckForNotDisplayed,
            shouldReportResultToObserver: isAssertions
        )
        
        let result = interactionPerformer.performInteraction(interaction: interaction)
        
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    // MARK: - AlmightyElementChecks
    
    func with(settings: ElementSettings) -> AlmightyElementChecks {
        return EarlGreyPageObjectElementChecks(
            elementSettings: settings,
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory,
            snapshotsComparisonUtility: snapshotsComparisonUtility,
            isAssertions: isAssertions
        )
    }
    
    func checkText(checker: @escaping (String) -> (InteractionSpecificResult), checkSettings: CheckSettings) -> Bool {
        return performCheck(
            checkMatcher: EarlGreyMatchers.checkText(
                checker: { text in
                    switch checker(text) {
                    case .success:
                        return true
                    case .failure:
                        return false
                    }
                }
            ),
            checkSettings: checkSettings
        )
    }
    
    func checkAccessibilityLabel(checker: @escaping (String) -> (InteractionSpecificResult), checkSettings: CheckSettings) -> Bool {
        assertionFailure("not implemented")
        return false
    }
    
    func isNotDisplayed(checkSettings: CheckSettings) -> Bool {
        return performCheck(
            checkMatcher: EarlGreyMatchers.isNotDisplayed(),
            checkSettings: checkSettings,
            isCheckForNotDisplayed: true
        )
    }
    
    func isDisplayed(checkSettings: CheckSettings) -> Bool {
        return performCheck(
            checkMatcher: EarlGreyMatchers.isDisplayed(),
            checkSettings: checkSettings
        )
    }
    
    func hasValue(_ value: String, checkSettings: CheckSettings) -> Bool {
        return performCheck(
            checkMatcher: EarlGreyMatchers.hasValue(value),
            checkSettings: checkSettings
        )
    }
    
    func hasHostDefinedValue(forKey key: String, referenceValue: String, checkSettings: CheckSettings, comparator: HostDefinedValueComparator) -> Bool {
        assert(false, "not implemented")
        return false
    }
    
    func isEnabled(checkSettings: CheckSettings) -> Bool {
        return performCheck(
            checkMatcher: EarlGreyMatchers.isEnabled(),
            checkSettings: checkSettings
        )
    }
    
    func isDisabled(checkSettings: CheckSettings) -> Bool {
        return performCheck(
            checkMatcher: EarlGreyMatchers.isDisabled(),
            checkSettings: checkSettings
        )
    }
    
    func hasImage(_ image: UIImage, checkSettings: CheckSettings) -> Bool {
        return performCheck(
            checkMatcher: EarlGreyMatchers.hasImage(image),
            checkSettings: checkSettings
        )
    }
    
    func hasAnyImage(checkSettings: CheckSettings) -> Bool {
        return performCheck(
            checkMatcher: EarlGreyMatchers.hasAnyImage(),
            checkSettings: checkSettings
        )
    }
    
    func hasNoImage(checkSettings: CheckSettings) -> Bool {
        return performCheck(
            checkMatcher: EarlGreyMatchers.hasNoImage(),
            checkSettings: checkSettings
        )
    }
    
    func isScrollable(checkSettings: CheckSettings) -> Bool {
        return performCheck(
            checkMatcher: EarlGreyMatchers.isScrollable(),
            checkSettings: checkSettings
        )
    }
    
    func matchesReference(snapshot: String, checkSettings: CheckSettings) -> Bool {
        return performCheck(
            checkMatcher: EarlGreyMatchers.matchesReference(
                snapshot: snapshot,
                in: checkSettings.fileLineWhereExecuted.file,
                utility: snapshotsComparisonUtility
            ),
            checkSettings: checkSettings
        )
    }
    
    func matchesReference(image: UIImage, checkSettings: CheckSettings) -> Bool {
        assert(false, "not implemented")
        return false
    }
}
