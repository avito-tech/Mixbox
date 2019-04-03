import MixboxUiTestsFoundation

public final class GreyPageObjectDependenciesFactory: PageObjectDependenciesFactory {
    /*
     These dependencies might be a good start:
     
     interactionExecutionLogger
     testFailureRecorder
     ipcClient
     snapshotsComparisonUtility
     stepLogger
     pollingConfiguration
     elementFinder
     */
    
    private let interactionPerformerFactory: ElementInteractionWithDependenciesPerformerFactory
    private let interactionFactory: InteractionFactory
    private let pollingConfiguration: PollingConfiguration
    
    public init(
        interactionPerformerFactory: ElementInteractionWithDependenciesPerformerFactory,
        interactionFactory: InteractionFactory,
        pollingConfiguration: PollingConfiguration)
    {
        self.interactionPerformerFactory = interactionPerformerFactory
        self.interactionFactory = interactionFactory
        self.pollingConfiguration = pollingConfiguration
    }
    
    public func pageObjectElementFactory() -> PageObjectElementFactory {
        return GreyPageObjectElementFactory(
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory,
            pollingConfiguration: pollingConfiguration
        )
    }
    
    public func matcherBuilder() -> ElementMatcherBuilder {
        return ElementMatcherBuilder()
    }
}
