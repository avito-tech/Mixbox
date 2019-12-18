import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxFoundation
import MixboxInAppServices

// TODO: Share code between black-box and gray-box.
public final class GrayElementInteractionDependenciesFactory: ElementInteractionDependenciesFactory {
    private let elementSettings: ElementSettings
    private let grayBoxTestsDependenciesFactory: GrayBoxTestsDependenciesFactory
    
    init(
        elementSettings: ElementSettings,
        grayBoxTestsDependenciesFactory: GrayBoxTestsDependenciesFactory)
    {
        self.elementSettings = elementSettings
        self.grayBoxTestsDependenciesFactory = grayBoxTestsDependenciesFactory
    }
    
    // swiftlint:disable:next function_body_length
    public func elementInteractionDependencies(
        interaction: ElementInteraction,
        fileLine: FileLine,
        elementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer,
        retriableTimedInteractionState: RetriableTimedInteractionState,
        elementSettings: ElementSettings)
        -> ElementInteractionDependencies
    {
        let elementInfo = HumanReadableInteractionDescriptionBuilderSource(
            elementName: elementSettings.name
        )
        
        let interactionFailureResultFactory = actionInteractionFailureResultFactory(
            fileLine: fileLine
        )
        
        let interactionRetrier = self.interactionRetrier(
            elementSettings: elementSettings,
            retriableTimedInteractionState: retriableTimedInteractionState
        )
        
        let elementMatcherBuilder = grayBoxTestsDependenciesFactory.elementMatcherBuilder
        
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
            textTyper: GrayTextTyper(),
            menuItemProvider: GrayMenuItemProvider(
                elementMatcherBuilder: elementMatcherBuilder,
                elementFinder: grayBoxTestsDependenciesFactory.elementFinder,
                elementSimpleGesturesProvider: grayBoxTestsDependenciesFactory.elementSimpleGesturesProvider,
                runLoopSpinnerFactory: grayBoxTestsDependenciesFactory.runLoopSpinnerFactory
            ),
            keyboardEventInjector: grayBoxTestsDependenciesFactory.keyboardEventInjector,
            pasteboard: UikitPasteboard(uiPasteboard: .general),
            interactionPerformer: NestedInteractionPerformerImpl(
                elementInteractionDependenciesFactory: self,
                elementInteractionWithDependenciesPerformer: elementInteractionWithDependenciesPerformer,
                retriableTimedInteractionState: retriableTimedInteractionState,
                elementSettings: elementSettings,
                fileLine: fileLine,
                signpostActivityLogger: grayBoxTestsDependenciesFactory.signpostActivityLogger
            ),
            elementSimpleGesturesProvider: grayBoxTestsDependenciesFactory.elementSimpleGesturesProvider,
            eventGenerator:grayBoxTestsDependenciesFactory.eventGenerator,
            interactionRetrier: interactionRetrier,
            interactionResultMaker: InteractionResultMakerImpl(
                elementHierarchyDescriptionProvider: elementHierarchyDescriptionProvider(),
                screenshotTaker: grayBoxTestsDependenciesFactory.screenshotTaker,
                extendedStackTraceProvider: extendedStackTraceProvider(),
                fileLine: fileLine
            ),
            elementMatcherBuilder: elementMatcherBuilder,
            elementInfo: elementInfo,
            retriableTimedInteractionState: retriableTimedInteractionState,
            signpostActivityLogger: grayBoxTestsDependenciesFactory.signpostActivityLogger,
            applicationQuiescenceWaiter: grayBoxTestsDependenciesFactory.applicationQuiescenceWaiter
        )
    }
    
    // MARK: - Private
    
    private func elementHierarchyDescriptionProvider() -> ElementHierarchyDescriptionProvider {
        return GrayElementHierarchyDescriptionProvider(
            viewHierarchyProvider: ViewHierarchyProviderImpl()
        )
    }
    
    private func performerOfSpecificImplementationOfInteractionForVisibleElement(
        elementSettings: ElementSettings,
        interactionFailureResultFactory: InteractionFailureResultFactory)
        -> PerformerOfSpecificImplementationOfInteractionForVisibleElement
    {
        return PerformerOfSpecificImplementationOfInteractionForVisibleElementImpl(
            elementVisibilityChecker: grayBoxTestsDependenciesFactory.elementVisibilityChecker,
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
            applicationFrameProvider: grayBoxTestsDependenciesFactory.applicationFrameProvider,
            eventGenerator: grayBoxTestsDependenciesFactory.eventGenerator,
            retrier: grayBoxTestsDependenciesFactory.retrier
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
            retrier: grayBoxTestsDependenciesFactory.retrier,
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
            applicationStateProvider: GrayApplicationStateProvider(),
            messagePrefix: messagePrefix,
            interactionResultMaker: InteractionResultMakerImpl(
                elementHierarchyDescriptionProvider: elementHierarchyDescriptionProvider(),
                screenshotTaker: grayBoxTestsDependenciesFactory.screenshotTaker,
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
            elementFinder: grayBoxTestsDependenciesFactory.elementFinder,
            elementSettings: elementSettings
        )
    }
    
    private func scroller(
        elementSettings: ElementSettings)
        -> Scroller
    {
        return ScrollerImpl(
            scrollingHintsProvider: grayBoxTestsDependenciesFactory.scrollingHintsProvider,
            elementVisibilityChecker: grayBoxTestsDependenciesFactory.elementVisibilityChecker,
            elementResolver: elementResolver(
                elementSettings: elementSettings
            ),
            applicationFrameProvider: grayBoxTestsDependenciesFactory.applicationFrameProvider,
            eventGenerator: grayBoxTestsDependenciesFactory.eventGenerator,
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
