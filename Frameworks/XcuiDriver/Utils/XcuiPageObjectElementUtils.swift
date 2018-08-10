import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxIpcCommon
import MixboxReporting

private struct PerformResult<Type> {
    let result: Type?
    let interactionSpecificResult: InteractionSpecificResult
}

final class XcuiPageObjectElementUtils: AlmightyElementUtils {
    private let elementSettings: ElementSettings
    private let isAssertions: Bool
    private let interactionPerformerFactory: InteractionPerformerFactory
    private let interactionFactory: InteractionFactory
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let snapshotsComparisonUtility: SnapshotsComparisonUtility
    private let stepLogger: StepLogger
    
    init(
        elementSettings: ElementSettings,
        interactionPerformerFactory: InteractionPerformerFactory,
        interactionFactory: InteractionFactory,
        elementVisibilityChecker: ElementVisibilityChecker,
        snapshotsComparisonUtility: SnapshotsComparisonUtility,
        stepLogger: StepLogger,
        isAssertions: Bool)
    {
        self.elementSettings = elementSettings
        self.interactionPerformerFactory = interactionPerformerFactory
        self.interactionFactory = interactionFactory
        self.elementVisibilityChecker = elementVisibilityChecker
        self.snapshotsComparisonUtility = snapshotsComparisonUtility
        self.stepLogger = stepLogger
        self.isAssertions = isAssertions
    }
    
    // MARK: - Private
    
    private func perform<Type>(
        utilsSettings: UtilsSettings,
        minimalPercentageOfVisibleArea: CGFloat = 0.2,
        util: @escaping (_ element: XCUIElement, _ snapshot: ElementSnapshot) -> PerformResult<Type>)
        -> Type?
    {
        var result: Type?
    
        let specificImplementation = InteractionSpecificImplementation { element, snapshot  in
            let performUtilResult = util(element, snapshot)
            
            result = performUtilResult.result
            
            return performUtilResult.interactionSpecificResult
        }
        
        let interaction = interactionFactory.actionInteraction( // actionInteraction or checkInteraction or ?
            specificImplementation: specificImplementation,
            settings: ResolvedInteractionSettings(
                interactionSettings: utilsSettings,
                elementSettings: elementSettings
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
            isAssertions: isAssertions
        )
    }
    
    func takeSnapshot(utilsSettings: UtilsSettings) -> UIImage? {
        return perform(utilsSettings: utilsSettings, minimalPercentageOfVisibleArea: 0.0) {
            (element: XCUIElement, _: ElementSnapshot) -> PerformResult<UIImage> in
            
            PerformResult(
                result: element.screenshot().image,
                interactionSpecificResult: .success
            )
        }
    }
}
