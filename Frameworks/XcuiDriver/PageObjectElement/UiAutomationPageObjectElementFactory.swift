import MixboxUiTestsFoundation

final class UiAutomationPageObjectElementFactory: PageObjectElementFactory {
    // MARK: - Private properties
    private let uiAutomationHelperFactory: UiAutomationHelperFactory
    
    // MARK: - Init
    init(uiAutomationHelperFactory: UiAutomationHelperFactory) {
        self.uiAutomationHelperFactory = uiAutomationHelperFactory
    }
    
    // MARK: - PageObjectElementFactory
    func pageObjectElement(
        settings: ElementSettings)
        -> AlmightyElement
    {
        let actions = UiAutomationPageObjectElementActions(
            elementSettings: settings,
            interactionPerformerFactory: uiAutomationHelperFactory.interactionPerformerFactory(),
            interactionFactory: uiAutomationHelperFactory.interactionFactory(),
            elementVisibilityChecker: uiAutomationHelperFactory.elementVisibilityChecker(),
            keyboardEventInjector: uiAutomationHelperFactory.keyboardEventInjector()
        )
        
        let checks = UiAutomationPageObjectElementChecks(
            elementSettings: settings,
            interactionPerformerFactory: uiAutomationHelperFactory.interactionPerformerFactory(),
            interactionFactory: uiAutomationHelperFactory.interactionFactory(),
            elementVisibilityChecker: uiAutomationHelperFactory.elementVisibilityChecker(),
            snapshotsComparisonUtility: uiAutomationHelperFactory.snapshotsComparisonUtility,
            stepLogger: uiAutomationHelperFactory.stepLogger(),
            isAssertions: false
        )
        
        let asserts = UiAutomationPageObjectElementChecks(
            elementSettings: settings,
            interactionPerformerFactory: uiAutomationHelperFactory.interactionPerformerFactory(),
            interactionFactory: uiAutomationHelperFactory.interactionFactory(),
            elementVisibilityChecker: uiAutomationHelperFactory.elementVisibilityChecker(),
            snapshotsComparisonUtility: uiAutomationHelperFactory.snapshotsComparisonUtility,
            stepLogger: uiAutomationHelperFactory.stepLogger(),
            isAssertions: true
        )
        
        let utils = UiAutomationPageObjectElementUtils(
            elementSettings: settings,
            interactionPerformerFactory: uiAutomationHelperFactory.interactionPerformerFactory(),
            interactionFactory: uiAutomationHelperFactory.interactionFactory(),
            elementVisibilityChecker: uiAutomationHelperFactory.elementVisibilityChecker(),
            snapshotsComparisonUtility: uiAutomationHelperFactory.snapshotsComparisonUtility,
            stepLogger: uiAutomationHelperFactory.stepLogger(),
            isAssertions: false
        )
        
        return AlmightyElementImpl(
            settings: settings,
            actions: actions,
            checks: checks,
            asserts: asserts,
            utils: utils
        )
    }
}
