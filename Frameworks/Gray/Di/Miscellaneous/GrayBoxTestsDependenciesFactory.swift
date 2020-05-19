import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxFoundation
import MixboxIpcCommon
import MixboxInAppServices

// TODO: Share code between black-box and gray-box.
protocol GrayBoxTestsDependenciesFactory: class {
    var eventGenerator: EventGenerator { get }
    var elementSimpleGesturesProvider: ElementSimpleGesturesProvider { get }
    var applicationFrameProvider: ApplicationFrameProvider { get }
    var testFailureRecorder: TestFailureRecorder { get }
    var stepLogger: StepLogger { get }
    var elementVisibilityChecker: ElementVisibilityChecker { get }
    var keyboardEventInjector: SynchronousKeyboardEventInjector { get }
    var elementMatcherBuilder: ElementMatcherBuilder { get }
    var retrier: Retrier { get }
    var screenshotAttachmentsMaker: ScreenshotAttachmentsMaker { get }
    var dateProvider: DateProvider { get }
    var pollingConfiguration: PollingConfiguration { get }
    var elementFinder: ElementFinder { get }
    var scrollingHintsProvider: ScrollingHintsProvider { get }
    var screenshotTaker: ScreenshotTaker { get }
    var orderedWindowsProvider: OrderedWindowsProvider { get }
    var runLoopSpinnerFactory: RunLoopSpinnerFactory { get }
    var waiter: RunLoopSpinningWaiter { get }
    var signpostActivityLogger: SignpostActivityLogger { get }
    var applicationQuiescenceWaiter: ApplicationQuiescenceWaiter { get }
    var applicationWindowsProvider: ApplicationWindowsProvider { get }
}
