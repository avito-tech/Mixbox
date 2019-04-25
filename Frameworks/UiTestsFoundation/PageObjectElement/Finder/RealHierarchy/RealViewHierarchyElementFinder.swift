import MixboxFoundation
import MixboxReporting
import MixboxIpc
import MixboxIpcCommon

public final class RealViewHierarchyElementFinder: ElementFinder {
    private let ipcClient: IpcClient
    private let testFailureRecorder: TestFailureRecorder
    private let stepLogger: StepLogger
    private let screenshotTaker: ScreenshotTaker
    
    public init(
        ipcClient: IpcClient,
        testFailureRecorder: TestFailureRecorder,
        stepLogger: StepLogger,
        screenshotTaker: ScreenshotTaker)
    {
        self.ipcClient = ipcClient
        self.testFailureRecorder = testFailureRecorder
        self.stepLogger = stepLogger
        self.screenshotTaker = screenshotTaker
    }
    
    public func query(
        elementMatcher: ElementMatcher,
        waitForExistence: Bool)
        -> ElementQuery
    {
        return RealViewHierarchyElementQuery(
            ipcClient: ipcClient,
            elementMatcher: elementMatcher,
            testFailureRecorder: testFailureRecorder,
            stepLogger: stepLogger,
            screenshotTaker: screenshotTaker,
            waitForExistence: waitForExistence
        )
    }
}
