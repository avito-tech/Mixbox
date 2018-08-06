import MixboxUiTestsFoundation

final class EarlGreyPageObjectElementFactory: PageObjectElementFactory {
    // MARK: - Private properties
    private let earlGreyHelperFactory: EarlGreyHelperFactory
    
    // MARK: - Init
    init(earlGreyHelperFactory: EarlGreyHelperFactory) {
        self.earlGreyHelperFactory = earlGreyHelperFactory
    }    
        
    // MARK: - PageObjectElementFactory
    func pageObjectElement(
        settings: ElementSettings)
        -> AlmightyElement
    {
        let actions = EarlGreyPageObjectElementActions(
            elementSettings: settings,
            interactionPerformerFactory: earlGreyHelperFactory.interactionPerformerFactory(),
            interactionFactory: earlGreyHelperFactory.interactionFactory()
        )
        
        let checks = EarlGreyPageObjectElementChecks(
            elementSettings: settings,
            interactionPerformerFactory: earlGreyHelperFactory.interactionPerformerFactory(),
            interactionFactory: earlGreyHelperFactory.interactionFactory(),
            snapshotsComparisonUtility: earlGreyHelperFactory.snapshotsComparisonUtility,
            isAssertions: false
        )
        
        let asserts = EarlGreyPageObjectElementChecks(
            elementSettings: settings,
            interactionPerformerFactory: earlGreyHelperFactory.interactionPerformerFactory(),
            interactionFactory: earlGreyHelperFactory.interactionFactory(),
            snapshotsComparisonUtility: earlGreyHelperFactory.snapshotsComparisonUtility,
            isAssertions: true
        )
        
        let utils = EarlGreyPageObjectElementUtils(
            elementSettings: settings,
            interactionPerformerFactory: earlGreyHelperFactory.interactionPerformerFactory(),
            interactionFactory: earlGreyHelperFactory.interactionFactory()
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
