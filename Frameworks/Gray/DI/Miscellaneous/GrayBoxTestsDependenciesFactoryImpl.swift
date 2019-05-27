import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxReporting

// TODO: Share code between black-box and gray-box.
final class GrayBoxTestsDependenciesFactoryImpl: GrayBoxTestsDependenciesFactory {
    let retrier: Retrier
    let applicationFrameProvider: ApplicationFrameProvider
    let eventGenerator: EventGenerator
    let testFailureRecorder: TestFailureRecorder
    let elementVisibilityChecker: ElementVisibilityChecker
    let stepLogger: StepLogger
    let elementFinder: ElementFinder
    let scrollingHintsProvider: ScrollingHintsProvider
    let keyboardEventInjector: KeyboardEventInjector
    let pollingConfiguration: PollingConfiguration
    let screenshotTaker: ScreenshotTaker
    let windowsProvider: WindowsProvider
    let elementSimpleGesturesProvider: ElementSimpleGesturesProvider
    let runLoopSpinnerFactory: RunLoopSpinnerFactory
    let spinner: Spinner
    
    // MARK: - Init
    
    init(
        testFailureRecorder: TestFailureRecorder,
        elementVisibilityChecker: ElementVisibilityChecker,
        scrollingHintsProvider: ScrollingHintsProvider,
        keyboardEventInjector: KeyboardEventInjector,
        stepLogger: StepLogger,
        pollingConfiguration: PollingConfiguration,
        elementFinder: ElementFinder,
        screenshotTaker: ScreenshotTaker,
        windowsProvider: WindowsProvider,
        spinner: Spinner)
    {
        self.testFailureRecorder = testFailureRecorder
        self.elementVisibilityChecker = elementVisibilityChecker
        self.scrollingHintsProvider = scrollingHintsProvider
        self.stepLogger = stepLogger
        self.keyboardEventInjector = keyboardEventInjector
        self.elementFinder = elementFinder
        self.pollingConfiguration = pollingConfiguration
        self.screenshotTaker = screenshotTaker
        self.windowsProvider = windowsProvider
        
        self.spinner = spinner
        self.runLoopSpinnerFactory = RunLoopSpinnerFactoryImpl(
            runLoopModesStackProvider: RunLoopModesStackProviderImpl()
        )
        
        let touchPerformer = TouchPerformerImpl(
            multiTouchCommandExecutor: MultiTouchCommandExecutorImpl(
                touchInjectorFactory: TouchInjectorFactoryImpl(
                    currentAbsoluteTimeProvider: MachCurrentAbsoluteTimeProvider(),
                    runLoopSpinnerFactory: runLoopSpinnerFactory
                )
            )
        )
        
        let windowForPointProvider = WindowForPointProviderImpl(
            windowsProvider: windowsProvider
        )
        
        elementSimpleGesturesProvider = GrayElementSimpleGesturesProvider(
            touchPerformer: touchPerformer,
            windowForPointProvider: windowForPointProvider
        )
        
        applicationFrameProvider = GrayApplicationFrameProvider()
        
        eventGenerator = GrayEventGenerator(
            touchPerformer: touchPerformer,
            windowForPointProvider: windowForPointProvider,
            pathGestureUtils: PathGestureUtilsFactoryImpl().pathGestureUtils()
        )
        
        retrier = RetrierImpl(
            pollingConfiguration: pollingConfiguration,
            spinner: spinner
        )
    }
    
    // MARK: - GrayBoxTestsDependenciesFactory
    
    var elementMatcherBuilder: ElementMatcherBuilder {
        return ElementMatcherBuilder(
            screenshotTaker: screenshotTaker
        )
    }
    
    var screenshotAttachmentsMaker: ScreenshotAttachmentsMaker {
        return ScreenshotAttachmentsMakerImpl(
            imageHashCalculator: DHashV0ImageHashCalculator(),
            screenshotTaker: screenshotTaker
        )
    }
    
    var dateProvider: DateProvider {
        return SystemClockDateProvider()
    }
}
