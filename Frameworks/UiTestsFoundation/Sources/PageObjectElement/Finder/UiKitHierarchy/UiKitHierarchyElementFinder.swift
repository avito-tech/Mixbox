import MixboxFoundation
import MixboxTestsFoundation
import MixboxIpc
import MixboxIpcCommon

public final class UiKitHierarchyElementFinder: ElementFinder {
    private let ipcClient: SynchronousIpcClient
    private let testFailureRecorder: TestFailureRecorder
    private let stepLogger: StepLogger
    private let applicationScreenshotTaker: ApplicationScreenshotTaker
    private let performanceLogger: PerformanceLogger
    private let dateProvider: DateProvider
    
    public init(
        ipcClient: SynchronousIpcClient,
        testFailureRecorder: TestFailureRecorder,
        stepLogger: StepLogger,
        applicationScreenshotTaker: ApplicationScreenshotTaker,
        performanceLogger: PerformanceLogger,
        dateProvider: DateProvider)
    {
        self.ipcClient = ipcClient
        self.testFailureRecorder = testFailureRecorder
        self.stepLogger = stepLogger
        self.applicationScreenshotTaker = applicationScreenshotTaker
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
            applicationScreenshotTaker: applicationScreenshotTaker,
            performanceLogger: performanceLogger,
            dateProvider: dateProvider,
            elementFunctionDeclarationLocation: elementFunctionDeclarationLocation
        )
    }
}
