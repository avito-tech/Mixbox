import MixboxTestsFoundation
import MixboxFoundation
import MixboxDi

open class BaseElementInteractionDependenciesFactory: ElementInteractionDependenciesFactory {
    private let parentDi: DependencyResolver
    private let dependencyInjectionFactory: DependencyInjectionFactory
    
    public init(
        dependencyResolver: DependencyResolver,
        dependencyInjectionFactory: DependencyInjectionFactory)
    {
        self.parentDi = dependencyResolver
        self.dependencyInjectionFactory = dependencyInjectionFactory
    }
    
    open func registerSpecificDependencies(di: DependencyRegisterer, fileLine: FileLine) {
        // should be overriden
    }
    
    // swiftlint:disable:next function_body_length
    public func elementInteractionDependencies(
        interaction: ElementInteraction,
        fileLine: FileLine,
        elementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer,
        retriableTimedInteractionState: RetriableTimedInteractionState,
        elementSettings: ElementSettings,
        interactionSettings: InteractionSettings)
        -> ElementInteractionDependencies
    {
        let di = makeDi()
        
        di.register(type: ElementInteractionWithDependenciesPerformer.self) { _ in
            elementInteractionWithDependenciesPerformer
        }
        di.register(type: ElementSettings.self) { _ in
            elementSettings
        }
        di.register(type: InteractionSettings.self) { _ in
            interactionSettings
        }
        di.register(type: ElementInteraction.self) { _ in
            interaction
        }
        di.register(type: RetriableTimedInteractionState.self) { _ in
            retriableTimedInteractionState
        }
        di.register(type: HumanReadableInteractionDescriptionBuilderSource.self) { _ in
            HumanReadableInteractionDescriptionBuilderSource(
                elementName: elementSettings.name
            )
        }
        di.register(type: InteractionResultMaker.self) { di in
            InteractionResultMakerImpl(
                elementHierarchyDescriptionProvider: try di.resolve(),
                deviceScreenshotTaker: try di.resolve(),
                extendedStackTraceProvider: try di.resolve(),
                fileLine: fileLine
            )
        }
        di.register(type: InteractionFailureResultFactory.self) { di in
            InteractionFailureResultFactoryImpl(
                applicationStateProvider: try di.resolve(),
                messagePrefix: "Действие неуспешно",
                interactionResultMaker: try di.resolve()
            )
        }
        di.register(type: InteractionRetrier.self) { di in
            InteractionRetrierImpl(
                dateProvider: try di.resolve(),
                timeout: interactionSettings.interactionTimeout,
                retrier: try di.resolve(),
                retriableTimedInteractionState: try di.resolve()
            )
        }
        di.register(type: SnapshotForInteractionResolver.self) { di in
            SnapshotForInteractionResolverImpl(
                retriableTimedInteractionState: try di.resolve(),
                interactionRetrier: try di.resolve(),
                performerOfSpecificImplementationOfInteractionForVisibleElement: try di.resolve(),
                interactionFailureResultFactory: try di.resolve(),
                elementResolverWithScrollingAndRetries: try di.resolve()
            )
        }
        di.register(type: NestedInteractionPerformer.self) { di in
            NestedInteractionPerformerImpl(
                elementInteractionDependenciesFactory: self,
                elementInteractionWithDependenciesPerformer: try di.resolve(),
                retriableTimedInteractionState: try di.resolve(),
                elementSettings: try di.resolve(),
                fileLine: fileLine,
                performanceLogger: try di.resolve()
            )
        }
        di.register(type: InteractionResultMaker.self) { di in
            InteractionResultMakerImpl(
                elementHierarchyDescriptionProvider: try di.resolve(),
                deviceScreenshotTaker: try di.resolve(),
                extendedStackTraceProvider: try di.resolve(),
                fileLine: fileLine
            )
        }
        di.register(type: PerformerOfSpecificImplementationOfInteractionForVisibleElement.self) { di in
            PerformerOfSpecificImplementationOfInteractionForVisibleElementImpl(
                elementVisibilityChecker: try di.resolve(),
                interactionSettings: try di.resolve(),
                interactionFailureResultFactory: try di.resolve(),
                scroller: try di.resolve()
            )
        }
        di.register(type: ElementResolverWithScrollingAndRetries.self) { di in
            ElementResolverWithScrollingAndRetriesImpl(
                elementResolver: try di.resolve(),
                interactionSettings: try di.resolve(),
                applicationFrameProvider: try di.resolve(),
                eventGenerator: try di.resolve(),
                retrier: try di.resolve()
            )
        }
        di.register(type: ElementResolver.self) { di in
            WaitingForQuiescenceElementResolver(
                elementResolver: ElementResolverImpl(
                    elementFinder: try di.resolve(),
                    interactionSettings: try di.resolve()
                ),
                applicationQuiescenceWaiter: try di.resolve()
            )
        }
        di.register(type: Scroller.self) { di in
            ScrollerImpl(
                scrollingHintsProvider: try di.resolve(),
                elementVisibilityChecker: try di.resolve(),
                elementResolver: try di.resolve(),
                applicationFrameProvider: try di.resolve(),
                eventGenerator: try di.resolve(),
                interactionSettings: try di.resolve()
            )
        }
        
        registerSpecificDependencies(di: di, fileLine: fileLine)
        
        return ElementInteractionDependenciesImpl(
            dependencyResolver: MixboxDiTestFailingDependencyResolver(
                dependencyResolver: di
            )
        )
    }
    
    private func makeDi() -> DependencyInjection {
        let localDi = dependencyInjectionFactory.dependencyInjection()
        
        return DelegatingDependencyInjection(
            dependencyResolver: CompoundDependencyResolver(
                resolvers: [localDi, parentDi]
            ),
            dependencyRegisterer: localDi
        )
    }
}
