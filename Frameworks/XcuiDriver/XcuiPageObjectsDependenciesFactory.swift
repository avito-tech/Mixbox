import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxIpcClients
import MixboxReporting

public final class XcuiPageObjectsDependenciesFactory: PageObjectsDependenciesFactory {
    private let interactionExecutionLogger: InteractionExecutionLogger
    private let testFailureRecorder: TestFailureRecorder
    private let ipcClient: IpcClient
    private let snapshotsComparisonUtility: SnapshotsComparisonUtility
    private let stepLogger: StepLogger
    
    public init(
        interactionExecutionLogger: InteractionExecutionLogger,
        testFailureRecorder: TestFailureRecorder,
        ipcClient: IpcClient,
        snapshotsComparisonUtility: SnapshotsComparisonUtility,
        stepLogger: StepLogger)
    {
        self.interactionExecutionLogger = interactionExecutionLogger
        self.testFailureRecorder = testFailureRecorder
        self.ipcClient = ipcClient
        self.snapshotsComparisonUtility = snapshotsComparisonUtility
        self.stepLogger = stepLogger
    }
    
    public func pageObjectElementFactory() -> PageObjectElementFactory {
        return XcuiPageObjectElementFactory(
            xcuiHelperFactory: XcuiHelperFactoryImpl(
                interactionExecutionLogger: interactionExecutionLogger,
                testFailureRecorder: testFailureRecorder,
                elementVisibilityChecker: ElementVisibilityCheckerImpl(
                    ipcClient: ipcClient
                ),
                scrollingHintsProvider: ScrollingHintsProviderImpl(
                    ipcClient: ipcClient
                ),
                keyboardEventInjector: KeyboardEventInjectorImpl(
                    ipcClient: ipcClient
                ),
                snapshotsComparisonUtility: snapshotsComparisonUtility,
                stepLogger: stepLogger
            )
        )
    }
}
