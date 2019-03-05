import MixboxUiTestsFoundation
import XCTest
import MixboxTestsFoundation

public final class InteractionFactoryImpl: InteractionFactory {
    private let elementFinder: ElementFinder
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let scrollingHintsProvider: ScrollingHintsProvider
    private let applicationProvider: ApplicationProvider
    private let applicationCoordinatesProvider: ApplicationCoordinatesProvider
    
    public init(
        elementFinder: ElementFinder,
        elementVisibilityChecker: ElementVisibilityChecker,
        scrollingHintsProvider: ScrollingHintsProvider,
        applicationProvider: ApplicationProvider,
        applicationCoordinatesProvider: ApplicationCoordinatesProvider)
    {
        self.elementFinder = elementFinder
        self.elementVisibilityChecker = elementVisibilityChecker
        self.scrollingHintsProvider = scrollingHintsProvider
        self.applicationProvider = applicationProvider
        self.applicationCoordinatesProvider = applicationCoordinatesProvider
    }
    
    public func actionInteraction(
        specificImplementation: InteractionSpecificImplementation,
        settings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat)
        -> Interaction
    {
        let interactionFailureResultFactory = actionInteractionFailureResultFactory(
            interactionName: settings.interactionName
        )
        
        return ActionInteraction(
            settings: settings,
            specificImplementation: specificImplementation,
            interactionRetrier: interactionRetrier(
                settings: settings
            ),
            performerOfSpecificImplementationOfInteractionForVisibleElement: performerOfSpecificImplementationOfInteractionForVisibleElement(
                elementSettings: settings.elementSettings,
                minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
                interactionFailureResultFactory: interactionFailureResultFactory
            ),
            interactionFailureResultFactory: interactionFailureResultFactory,
            elementResolverWithScrollingAndRetries: elementResolverWithScrollingAndRetries(
                settings: settings
            )
        )
    }
    
    public func checkInteraction(
        specificImplementation: InteractionSpecificImplementation,
        settings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat)
        -> Interaction
    {
        let interactionFailureResultFactory = checkInteractionFailureResultFactory(
            interactionName: settings.interactionName
        )
        
        return VisibleElementCheckInteraction(
            settings: settings,
            specificImplementation: specificImplementation,
            interactionRetrier: interactionRetrier(
                settings: settings
            ),
            performerOfSpecificImplementationOfInteractionForVisibleElement: performerOfSpecificImplementationOfInteractionForVisibleElement(
                elementSettings: settings.elementSettings,
                minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
                interactionFailureResultFactory: interactionFailureResultFactory
            ),
            interactionFailureResultFactory: interactionFailureResultFactory,
            elementResolverWithScrollingAndRetries: elementResolverWithScrollingAndRetries(
                settings: settings
            )
        )
    }
    
    public func checkForNotDisplayedInteraction(
        settings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat)
        -> Interaction
    {
        return InvisibilityCheckInteraction(
            settings: settings,
            interactionRetrier: interactionRetrier(
                settings: settings
            ),
            interactionFailureResultFactory: checkInteractionFailureResultFactory(
                interactionName: settings.interactionName
            ),
            elementResolverWithScrollingAndRetries: elementResolverWithScrollingAndRetries(
                settings: settings
            ),
            scroller: scroller(
                minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
                elementSettings: settings.elementSettings
            ),
            elementVisibilityChecker: elementVisibilityChecker,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
        )
    }
    
    // MARK: - Private
    
    private func performerOfSpecificImplementationOfInteractionForVisibleElement(
        elementSettings: ElementSettings,
        minimalPercentageOfVisibleArea: CGFloat,
        interactionFailureResultFactory: InteractionFailureResultFactory)
        -> PerformerOfSpecificImplementationOfInteractionForVisibleElement
    {
        return PerformerOfSpecificImplementationOfInteractionForVisibleElementImpl(
            elementVisibilityChecker: elementVisibilityChecker,
            elementSettings: elementSettings,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            interactionFailureResultFactory: interactionFailureResultFactory,
            scroller: scroller(
                minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
                elementSettings: elementSettings
            )
        )
    }
    
    private func elementResolverWithScrollingAndRetries(
        settings: ResolvedInteractionSettings)
        -> ElementResolverWithScrollingAndRetries
    {
        return ElementResolverWithScrollingAndRetriesImpl(
            elementResolver: elementResolver(
                elementSettings: settings.elementSettings
            ),
            elementSettings: settings.elementSettings,
            applicationProvider: applicationProvider,
            applicationCoordinatesProvider: applicationCoordinatesProvider,
            retrier: retrier(settings: settings)
        )
    }
    
private func interactionRetrier(
        settings: ResolvedInteractionSettings)
        -> InteractionRetrier
    {
        let defaultTimeout: TimeInterval = 15
        
        return InteractionRetrierImpl(
            dateProvider: dateProvider(),
            timeout: settings.elementSettings.searchTimeout ?? defaultTimeout,
            retrier: retrier(
                settings: settings
            )
        )
    }
    
    private func retrier(
        settings: ResolvedInteractionSettings)
        -> Retrier
    {
        return RetrierImpl(
            pollingConfiguration: settings.pollingConfiguration
        )
    }
    
    private func actionInteractionFailureResultFactory(
        interactionName: String)
        -> InteractionFailureResultFactory
    {
        return interactionFailureResultFactory(
            messagePrefix: "Действие неуспешно",
            interactionName: interactionName
        )
    }
    
    private func checkInteractionFailureResultFactory(
        interactionName: String)
        -> InteractionFailureResultFactory
    {
        return interactionFailureResultFactory(
            messagePrefix: "Проверка неуспешна",
            interactionName: interactionName
        )
    }
    
    private func interactionFailureResultFactory(
        messagePrefix: String,
        interactionName: String)
        -> InteractionFailureResultFactory
    {
        return InteractionFailureResultFactoryImpl(
            applicationProvider: applicationProvider,
            messagePrefix: messagePrefix,
            interactionName: interactionName
        )
    }
    
    private func elementResolver(
        elementSettings: ElementSettings)
        -> ElementResolver
    {
        return ElementResolverImpl(
            elementFinder: elementFinder,
            elementSettings: elementSettings
        )
    }
    
    private func scroller(
        minimalPercentageOfVisibleArea: CGFloat,
        elementSettings: ElementSettings)
        -> Scroller
    {
        return ScrollerImpl(
            scrollingHintsProvider: scrollingHintsProvider,
            elementVisibilityChecker: elementVisibilityChecker,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            elementResolver: elementResolver(
                elementSettings: elementSettings
            ),
            applicationProvider: applicationProvider,
            applicationCoordinatesProvider: applicationCoordinatesProvider,
            elementSettings: elementSettings
        )
    }
    
    private func dateProvider() -> DateProvider {
        return SystemClockDateProvider()
    }
}
