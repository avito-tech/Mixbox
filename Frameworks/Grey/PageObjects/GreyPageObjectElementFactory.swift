import MixboxUiTestsFoundation

public final class GreyPageObjectElementFactory: PageObjectElementFactory {
    private let interactionPerformerFactory: InteractionPerformerFactory
    private let interactionFactory: InteractionFactory
    private let pollingConfiguration: PollingConfiguration
    
    public init(
        interactionPerformerFactory: InteractionPerformerFactory,
        interactionFactory: InteractionFactory,
        pollingConfiguration: PollingConfiguration)
    {
        self.interactionPerformerFactory = interactionPerformerFactory
        self.interactionFactory = interactionFactory
        self.pollingConfiguration = pollingConfiguration
    }
    
    public func pageObjectElement(
        settings: ElementSettings)
        -> AlmightyElement
    {
        let actions = GreyPageObjectElementActions(
            elementSettings: settings
        )
        
        let checks = AlmightyElementChecksImpl(
            elementSettings: settings,
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory,
            isAssertions: false,
            pollingConfiguration: pollingConfiguration,
            elementMatcherBuilder: ElementMatcherBuilder()
        )
        
        let asserts = AlmightyElementChecksImpl(
            elementSettings: settings,
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory,
            isAssertions: true,
            pollingConfiguration: pollingConfiguration,
            elementMatcherBuilder: ElementMatcherBuilder()
        )
        
        return AlmightyElementImpl(
            settings: settings,
            actions: actions,
            checks: checks,
            asserts: asserts
        )
    }
}
