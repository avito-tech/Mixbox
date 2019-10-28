import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxFoundation

public final class XcuiElementInteractionDependenciesFactory: ElementInteractionDependenciesFactory {
    private let elementSettings: ElementSettings
    private let xcuiBasedTestsDependenciesFactory: XcuiBasedTestsDependenciesFactory
    
    init(
        elementSettings: ElementSettings,
        xcuiBasedTestsDependenciesFactory: XcuiBasedTestsDependenciesFactory)
    {
        self.elementSettings = elementSettings
        self.xcuiBasedTestsDependenciesFactory = xcuiBasedTestsDependenciesFactory
    }
    
    // swiftlint:disable function_body_length
    public func elementInteractionDependencies(
        interaction: ElementInteraction,
        fileLine: FileLine,
        elementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer,
        retriableTimedInteractionState: RetriableTimedInteractionState,
        elementSettings: ElementSettings)
        -> ElementInteractionDependencies
    {
        let elementInfo = HumanReadableInteractionDescriptionBuilderSource(
            elementName: elementSettings.elementName
        )
        
        let interactionFailureResultFactory = actionInteractionFailureResultFactory(
            fileLine: fileLine
        )
        
        let interactionRetrier = self.interactionRetrier(
            elementSettings: elementSettings,
            retriableTimedInteractionState: retriableTimedInteractionState
        )
        
        return ElementInteractionDependenciesImpl(
            snapshotResolver: SnapshotForInteractionResolverImpl(
                retriableTimedInteractionState: retriableTimedInteractionState,
                interactionRetrier: interactionRetrier,
                performerOfSpecificImplementationOfInteractionForVisibleElement: performerOfSpecificImplementationOfInteractionForVisibleElement(
                    elementSettings: elementSettings,
                    interactionFailureResultFactory: interactionFailureResultFactory
                ),
                interactionFailureResultFactory: interactionFailureResultFactory,
                elementResolverWithScrollingAndRetries: elementResolverWithScrollingAndRetries(
                    elementSettings: elementSettings
                )
            ),
            textTyper: XcuiTextTyper(
                applicationProvider: xcuiBasedTestsDependenciesFactory.applicationProvider
            ),
            menuItemProvider: XcuiMenuItemProvider(
                applicationProvider: xcuiBasedTestsDependenciesFactory.applicationProvider
            ),
            keyboardEventInjector: xcuiBasedTestsDependenciesFactory.keyboardEventInjector,
            pasteboard: xcuiBasedTestsDependenciesFactory.pasteboard,
            interactionPerformer: NestedInteractionPerformerImpl(
                elementInteractionDependenciesFactory: self,
                elementInteractionWithDependenciesPerformer: elementInteractionWithDependenciesPerformer,
                retriableTimedInteractionState: retriableTimedInteractionState,
                elementSettings: elementSettings,
                fileLine: fileLine,
                signpostActivityLogger: xcuiBasedTestsDependenciesFactory.signpostActivityLogger
            ),
            elementSimpleGesturesProvider: XcuiElementSimpleGesturesProvider(
                applicationProvider: xcuiBasedTestsDependenciesFactory.applicationProvider,
                applicationFrameProvider: xcuiBasedTestsDependenciesFactory.applicationFrameProvider,
                applicationCoordinatesProvider: xcuiBasedTestsDependenciesFactory.applicationCoordinatesProvider
            ),
            eventGenerator: XcuiEventGenerator(
                applicationProvider: xcuiBasedTestsDependenciesFactory.applicationProvider
            ),
            interactionRetrier: interactionRetrier,
            interactionResultMaker: InteractionResultMakerImpl(
                elementHierarchyDescriptionProvider: XcuiElementHierarchyDescriptionProvider(
                    applicationProvider: xcuiBasedTestsDependenciesFactory.applicationProvider
                ),
                screenshotTaker: xcuiBasedTestsDependenciesFactory.screenshotTaker,
                extendedStackTraceProvider: extendedStackTraceProvider(),
                fileLine: fileLine
            ),
            elementMatcherBuilder: xcuiBasedTestsDependenciesFactory.elementMatcherBuilder,
            elementInfo: elementInfo,
            retriableTimedInteractionState: retriableTimedInteractionState,
            signpostActivityLogger: xcuiBasedTestsDependenciesFactory.signpostActivityLogger
        )
    }
    
    // MARK: - Private
    
    private func performerOfSpecificImplementationOfInteractionForVisibleElement(
        elementSettings: ElementSettings,
        interactionFailureResultFactory: InteractionFailureResultFactory)
        -> PerformerOfSpecificImplementationOfInteractionForVisibleElement
    {
        return PerformerOfSpecificImplementationOfInteractionForVisibleElementImpl(
            elementVisibilityChecker: xcuiBasedTestsDependenciesFactory.elementVisibilityChecker,
            elementSettings: elementSettings,
            interactionFailureResultFactory: interactionFailureResultFactory,
            scroller: scroller(
                elementSettings: elementSettings
            )
        )
    }
    
    private func elementResolverWithScrollingAndRetries(
        elementSettings: ElementSettings)
        -> ElementResolverWithScrollingAndRetries
    {
        return ElementResolverWithScrollingAndRetriesImpl(
            elementResolver: elementResolver(
                elementSettings: elementSettings
            ),
            elementSettings: elementSettings,
            applicationFrameProvider: xcuiBasedTestsDependenciesFactory.applicationFrameProvider,
            eventGenerator: xcuiBasedTestsDependenciesFactory.eventGenerator,
            retrier: xcuiBasedTestsDependenciesFactory.retrier
        )
    }
    
    private func interactionRetrier(
        elementSettings: ElementSettings,
        retriableTimedInteractionState: RetriableTimedInteractionState)
        -> InteractionRetrier
    {
        return InteractionRetrierImpl(
            dateProvider: dateProvider(),
            timeout: elementSettings.interactionTimeout,
            retrier: xcuiBasedTestsDependenciesFactory.retrier,
            retriableTimedInteractionState: retriableTimedInteractionState
        )
    }
    
    private func actionInteractionFailureResultFactory(
        fileLine: FileLine)
        -> InteractionFailureResultFactory
    {
        return interactionFailureResultFactory(
            messagePrefix: "Действие неуспешно",
            fileLine: fileLine
        )
    }
    
    private func interactionFailureResultFactory(
        messagePrefix: String,
        fileLine: FileLine)
        -> InteractionFailureResultFactory
    {
        return InteractionFailureResultFactoryImpl(
            applicationStateProvider: XcuiApplicationStateProvider(
                applicationProvider: xcuiBasedTestsDependenciesFactory.applicationProvider
            ),
            messagePrefix: messagePrefix,
            interactionResultMaker: InteractionResultMakerImpl(
                elementHierarchyDescriptionProvider: XcuiElementHierarchyDescriptionProvider(
                    applicationProvider: xcuiBasedTestsDependenciesFactory.applicationProvider
                ),
                screenshotTaker: xcuiBasedTestsDependenciesFactory.screenshotTaker,
                extendedStackTraceProvider: extendedStackTraceProvider(),
                fileLine: fileLine
            )
        )
    }
    
    private func elementResolver(
        elementSettings: ElementSettings)
        -> ElementResolver
    {
        return ElementResolverImpl(
            elementFinder: xcuiBasedTestsDependenciesFactory.elementFinder,
            elementSettings: elementSettings
        )
    }
    
    private func scroller(
        elementSettings: ElementSettings)
        -> Scroller
    {
        return ScrollerImpl(
            scrollingHintsProvider: xcuiBasedTestsDependenciesFactory.scrollingHintsProvider,
            elementVisibilityChecker: xcuiBasedTestsDependenciesFactory.elementVisibilityChecker,
            elementResolver: WaitingForQuiescenceElementResolver(
                elementResolver: elementResolver(
                    elementSettings: elementSettings
                ),
                applicationProvider: xcuiBasedTestsDependenciesFactory.applicationProvider
            ),
            applicationFrameProvider: xcuiBasedTestsDependenciesFactory.applicationFrameProvider,
            eventGenerator: xcuiBasedTestsDependenciesFactory.eventGenerator,
            elementSettings: elementSettings
        )
    }
    
    private func dateProvider() -> DateProvider {
        return SystemClockDateProvider()
    }
    
    private func extendedStackTraceProvider() -> ExtendedStackTraceProvider {
        return ExtendedStackTraceProviderImpl(
            stackTraceProvider: StackTraceProviderImpl(),
            extendedStackTraceEntryFromCallStackSymbolsConverter: ExtendedStackTraceEntryFromStackTraceEntryConverterImpl()
        )
    }
}
