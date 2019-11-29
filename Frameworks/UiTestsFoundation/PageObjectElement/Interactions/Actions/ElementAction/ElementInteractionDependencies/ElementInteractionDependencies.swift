import MixboxFoundation
import MixboxIpcCommon

// Isolates Actions of testing technology (XCTest vs GrayBox).
// Contains technology dependent
public protocol ElementInteractionDependencies: class {
    var retriableTimedInteractionState: RetriableTimedInteractionState { get }
    var elementInfo: HumanReadableInteractionDescriptionBuilderSource { get }
    var interactionPerformer: NestedInteractionPerformer { get }
    var snapshotResolver: SnapshotForInteractionResolver { get }
    var elementSimpleGesturesProvider: ElementSimpleGesturesProvider { get }
    var textTyper: TextTyper { get }
    var keyboardEventInjector: KeyboardEventInjector { get }
    var pasteboard: Pasteboard { get }
    var menuItemProvider: MenuItemProvider { get }
    var eventGenerator: EventGenerator { get }
    var interactionRetrier: InteractionRetrier { get }
    var interactionResultMaker: InteractionResultMaker { get }
    var elementMatcherBuilder: ElementMatcherBuilder { get }
    var signpostActivityLogger: SignpostActivityLogger { get }
    var applicationQuiescenceWaiter: ApplicationQuiescenceWaiter { get }
}
