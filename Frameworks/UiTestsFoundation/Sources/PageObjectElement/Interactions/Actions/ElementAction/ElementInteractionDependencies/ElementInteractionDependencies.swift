import MixboxFoundation
import MixboxTestsFoundation
import MixboxIpcCommon

public protocol ElementInteractionDependencies: AnyObject {
    var di: TestFailingDependencyResolver { get }
}

extension ElementInteractionDependencies {
    public var retriableTimedInteractionState: RetriableTimedInteractionState { di.resolve() }
    public var elementInfo: HumanReadableInteractionDescriptionBuilderSource { di.resolve() }
    public var interactionPerformer: NestedInteractionPerformer { di.resolve() }
    public var snapshotResolver: SnapshotForInteractionResolver { di.resolve() }
    public var elementSimpleGesturesProvider: ElementSimpleGesturesProvider { di.resolve() }
    public var textTyper: TextTyper { di.resolve() }
    public var keyboardEventInjector: SynchronousKeyboardEventInjector { di.resolve() }
    public var pasteboard: Pasteboard { di.resolve() }
    public var menuItemProvider: MenuItemProvider { di.resolve() }
    public var eventGenerator: EventGenerator { di.resolve() }
    public var interactionRetrier: InteractionRetrier { di.resolve() }
    public var interactionResultMaker: InteractionResultMaker { di.resolve() }
    public var elementMatcherBuilder: ElementMatcherBuilder { di.resolve() }
    public var performanceLogger: PerformanceLogger { di.resolve() }
    public var applicationQuiescenceWaiter: ApplicationQuiescenceWaiter { di.resolve() }
}
