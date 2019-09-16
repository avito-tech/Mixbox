import MixboxFoundation
import MixboxReporting
import MixboxIpc
import MixboxIpcCommon

public final class RealViewHierarchyElementFinder: ElementFinder {
    private let ipcClient: IpcClient
    private let testFailureRecorder: TestFailureRecorder
    private let stepLogger: StepLogger
    private let screenshotTaker: ScreenshotTaker
    private let signpostActivityLogger: SignpostActivityLogger
    
    public init(
        ipcClient: IpcClient,
        testFailureRecorder: TestFailureRecorder,
        stepLogger: StepLogger,
        screenshotTaker: ScreenshotTaker,
        signpostActivityLogger: SignpostActivityLogger)
    {
        self.ipcClient = ipcClient
        self.testFailureRecorder = testFailureRecorder
        self.stepLogger = stepLogger
        self.screenshotTaker = screenshotTaker
        self.signpostActivityLogger = signpostActivityLogger
    }
    
    public func query(
        elementMatcher: ElementMatcher)
        -> ElementQuery
    {
        return RealViewHierarchyElementQuery(
            ipcClient: ipcClient,
            elementMatcher: elementMatcher,
            testFailureRecorder: testFailureRecorder,
            stepLogger: stepLogger,
            screenshotTaker: screenshotTaker,
            signpostActivityLogger: signpostActivityLogger
        )
    }
}
