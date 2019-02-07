import MixboxUiTestsFoundation

final class XcuiPageObjectElementFactory: PageObjectElementFactory {
    // MARK: - Private properties
    private let xcuiHelperFactory: XcuiHelperFactory
    
    // MARK: - Init
    init(xcuiHelperFactory: XcuiHelperFactory) {
        self.xcuiHelperFactory = xcuiHelperFactory
    }
    
    // MARK: - PageObjectElementFactory
    func pageObjectElement(
        settings: ElementSettings)
        -> AlmightyElement
    {
        let actions = XcuiPageObjectElementActions(
            elementSettings: settings,
            interactionPerformerFactory: xcuiHelperFactory.interactionPerformerFactory(),
            interactionFactory: xcuiHelperFactory.interactionFactory(),
            elementVisibilityChecker: xcuiHelperFactory.elementVisibilityChecker(),
            keyboardEventInjector: xcuiHelperFactory.keyboardEventInjector(),
            pollingConfiguration: xcuiHelperFactory.pollingConfiguration(),
            applicationProvider: xcuiHelperFactory.applicationProvider,
            applicationCoordinatesProvider: xcuiHelperFactory.applicationCoordinatesProvider,
            eventGenerator: xcuiHelperFactory.eventGenerator
        )
        
        let checks = XcuiPageObjectElementChecks(
            elementSettings: settings,
            interactionPerformerFactory: xcuiHelperFactory.interactionPerformerFactory(),
            interactionFactory: xcuiHelperFactory.interactionFactory(),
            elementVisibilityChecker: xcuiHelperFactory.elementVisibilityChecker(),
            snapshotsComparisonUtility: xcuiHelperFactory.snapshotsComparisonUtility,
            stepLogger: xcuiHelperFactory.stepLogger(),
            isAssertions: false,
            pollingConfiguration: xcuiHelperFactory.pollingConfiguration()
        )
        
        let asserts = XcuiPageObjectElementChecks(
            elementSettings: settings,
            interactionPerformerFactory: xcuiHelperFactory.interactionPerformerFactory(),
            interactionFactory: xcuiHelperFactory.interactionFactory(),
            elementVisibilityChecker: xcuiHelperFactory.elementVisibilityChecker(),
            snapshotsComparisonUtility: xcuiHelperFactory.snapshotsComparisonUtility,
            stepLogger: xcuiHelperFactory.stepLogger(),
            isAssertions: true,
            pollingConfiguration: xcuiHelperFactory.pollingConfiguration()
        )
        
        return AlmightyElementImpl(
            settings: settings,
            actions: actions,
            checks: checks,
            asserts: asserts
        )
    }
}
