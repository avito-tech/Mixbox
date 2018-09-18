import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxIpcCommon
import MixboxReporting

private struct PerformResult<Type> {
    let result: Type?
    let interactionSpecificResult: InteractionSpecificResult
}

// NOTE: This class should be removed.
// Page object elements will only contain properties and actions in future.
final class XcuiPageObjectElementUtils: AlmightyElementUtils {
    private let elementSettings: ElementSettings
    private let isAssertions: Bool
    private let interactionPerformerFactory: InteractionPerformerFactory
    private let interactionFactory: InteractionFactory
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let snapshotsComparisonUtility: SnapshotsComparisonUtility
    private let stepLogger: StepLogger
    private let pollingConfiguration: PollingConfiguration
    
    init(
        elementSettings: ElementSettings,
        interactionPerformerFactory: InteractionPerformerFactory,
        interactionFactory: InteractionFactory,
        elementVisibilityChecker: ElementVisibilityChecker,
        snapshotsComparisonUtility: SnapshotsComparisonUtility,
        stepLogger: StepLogger,
        isAssertions: Bool,
        pollingConfiguration: PollingConfiguration)
    {
        self.elementSettings = elementSettings
        self.interactionPerformerFactory = interactionPerformerFactory
        self.interactionFactory = interactionFactory
        self.elementVisibilityChecker = elementVisibilityChecker
        self.snapshotsComparisonUtility = snapshotsComparisonUtility
        self.stepLogger = stepLogger
        self.isAssertions = isAssertions
        self.pollingConfiguration = pollingConfiguration
    }
    
    // MARK: - Private
    
    private func perform<Type>(
        utilsSettings: UtilsSettings,
        minimalPercentageOfVisibleArea: CGFloat = 0.2,
        util: @escaping (_ snapshot: ElementSnapshot) -> PerformResult<Type>)
        -> Type?
    {
        var result: Type?
    
        let specificImplementation = InteractionSpecificImplementation { snapshot in
            let performUtilResult = util(snapshot)
            
            result = performUtilResult.result
            
            return performUtilResult.interactionSpecificResult
        }
        
        let interaction = interactionFactory.actionInteraction( // actionInteraction or checkInteraction or ?
            specificImplementation: specificImplementation,
            settings: ResolvedInteractionSettings(
                interactionSettings: utilsSettings,
                elementSettings: elementSettings,
                pollingConfiguration: pollingConfiguration
            ),
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
        )
        
        let interactionPerformer = interactionPerformerFactory.performerForInteraction(
            shouldReportResultToObserver: isAssertions
        )
    
        switch interactionPerformer.performInteraction(interaction: interaction) {
        case .success:
            return result
        case .failure:
            return nil
        }
    }
    
    // MARK: - AlmightyElementUtils
    
    func with(settings: ElementSettings) -> AlmightyElementUtils {
        return XcuiPageObjectElementUtils(
            elementSettings: settings,
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory,
            elementVisibilityChecker: elementVisibilityChecker,
            snapshotsComparisonUtility: snapshotsComparisonUtility,
            stepLogger: stepLogger,
            isAssertions: isAssertions,
            pollingConfiguration: pollingConfiguration
        )
    }
    
    func takeSnapshot(utilsSettings: UtilsSettings) -> UIImage? {
        return perform(utilsSettings: utilsSettings, minimalPercentageOfVisibleArea: 0.0) {
            (snapshot: ElementSnapshot) -> PerformResult<UIImage> in
            
            PerformResult(
                result: snapshot.image(),
                interactionSpecificResult: .success
            )
        }
    }
}
