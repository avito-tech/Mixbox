import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxFoundation
import MixboxIpcCommon

protocol XcuiBasedTestsDependenciesFactory: class {
    var eventGenerator: EventGenerator { get }
    var applicationProvider: ApplicationProvider { get }
    var applicationFrameProvider: ApplicationFrameProvider { get }
    var applicationCoordinatesProvider: ApplicationCoordinatesProvider { get }
    var testFailureRecorder: TestFailureRecorder { get }
    var stepLogger: StepLogger { get }
    var elementVisibilityChecker: ElementVisibilityChecker { get }
    var keyboardEventInjector: KeyboardEventInjector { get }
    var elementMatcherBuilder: ElementMatcherBuilder { get }
    var retrier: Retrier { get }
    var screenshotAttachmentsMaker: ScreenshotAttachmentsMaker { get }
    var dateProvider: DateProvider { get }
    var pollingConfiguration: PollingConfiguration { get }
    var elementFinder: ElementFinder { get }
    var scrollingHintsProvider: ScrollingHintsProvider { get }
    var screenshotTaker: ScreenshotTaker { get }
    var pasteboard: Pasteboard { get }
    var signpostActivityLogger: SignpostActivityLogger { get }
    var applicationQuiescenceWaiter: ApplicationQuiescenceWaiter { get }
}
