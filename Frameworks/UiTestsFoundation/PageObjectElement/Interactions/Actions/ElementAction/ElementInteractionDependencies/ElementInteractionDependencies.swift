import MixboxFoundation
import MixboxTestsFoundation
import MixboxIpcCommon

public protocol ElementInteractionDependencies: class {
    var di: TestFailingDependencyResolver { get }
}

extension ElementInteractionDependencies {
    var retriableTimedInteractionState: RetriableTimedInteractionState { di.resolve() }
    var elementInfo: HumanReadableInteractionDescriptionBuilderSource { di.resolve() }
    var interactionPerformer: NestedInteractionPerformer { di.resolve() }
    var snapshotResolver: SnapshotForInteractionResolver { di.resolve() }
    var elementSimpleGesturesProvider: ElementSimpleGesturesProvider { di.resolve() }
    var textTyper: TextTyper { di.resolve() }
    var keyboardEventInjector: SynchronousKeyboardEventInjector { di.resolve() }
    var pasteboard: Pasteboard { di.resolve() }
    var menuItemProvider: MenuItemProvider { di.resolve() }
    var eventGenerator: EventGenerator { di.resolve() }
    var interactionRetrier: InteractionRetrier { di.resolve() }
    var interactionResultMaker: InteractionResultMaker { di.resolve() }
    var elementMatcherBuilder: ElementMatcherBuilder { di.resolve() }
    var performanceLogger: PerformanceLogger { di.resolve() }
    var applicationQuiescenceWaiter: ApplicationQuiescenceWaiter { di.resolve() }
}
