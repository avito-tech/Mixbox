import MixboxFoundation
import MixboxTestsFoundation
import MixboxIpc
import MixboxIpcCommon

public final class UiKitHierarchyElementFinder: ElementFinder {
    private let ipcClient: SynchronousIpcClient
    private let testFailureRecorder: TestFailureRecorder
    private let stepLogger: StepLogger
    private let screenshotTaker: ScreenshotTaker
    private let performanceLogger: PerformanceLogger
    private let dateProvider: DateProvider
    
    public init(
        ipcClient: SynchronousIpcClient,
        testFailureRecorder: TestFailureRecorder,
        stepLogger: StepLogger,
        screenshotTaker: ScreenshotTaker,
        performanceLogger: PerformanceLogger,
        dateProvider: DateProvider)
    {
        self.ipcClient = ipcClient
        self.testFailureRecorder = testFailureRecorder
        self.stepLogger = stepLogger
        self.screenshotTaker = screenshotTaker
        self.performanceLogger = performanceLogger
        self.dateProvider = dateProvider
    }
    
    public func query(
        elementMatcher: ElementMatcher,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation)
        -> ElementQuery
    {
        return UiKitHierarchyElementQuery(
            ipcClient: ipcClient,
            elementMatcher: elementMatcher,
            testFailureRecorder: testFailureRecorder,
            stepLogger: stepLogger,
            screenshotTaker: screenshotTaker,
            performanceLogger: performanceLogger,
            dateProvider: dateProvider,
            elementFunctionDeclarationLocation: elementFunctionDeclarationLocation
        )
    }
}
