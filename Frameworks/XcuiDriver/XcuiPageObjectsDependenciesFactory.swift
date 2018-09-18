import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxIpcClients
import MixboxReporting

public final class XcuiPageObjectDependenciesFactory: PageObjectDependenciesFactory {
    private let interactionExecutionLogger: InteractionExecutionLogger
    private let testFailureRecorder: TestFailureRecorder
    private let ipcClient: IpcClient
    private let snapshotsComparisonUtility: SnapshotsComparisonUtility
    private let stepLogger: StepLogger
    private let pollingConfiguration: PollingConfiguration
    private let snapshotCaches: SnapshotCaches
    private let elementFinder: ElementFinder
    
    public init(
        interactionExecutionLogger: InteractionExecutionLogger,
        testFailureRecorder: TestFailureRecorder,
        ipcClient: IpcClient,
        snapshotsComparisonUtility: SnapshotsComparisonUtility,
        stepLogger: StepLogger,
        pollingConfiguration: PollingConfiguration,
        snapshotCaches: SnapshotCaches,
        elementFinder: ElementFinder)
    {
        self.interactionExecutionLogger = interactionExecutionLogger
        self.testFailureRecorder = testFailureRecorder
        self.ipcClient = ipcClient
        self.snapshotsComparisonUtility = snapshotsComparisonUtility
        self.stepLogger = stepLogger
        self.pollingConfiguration = pollingConfiguration
        self.snapshotCaches = snapshotCaches
        self.elementFinder = elementFinder
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
                stepLogger: stepLogger,
                pollingConfiguration: pollingConfiguration,
                snapshotCaches: snapshotCaches,
                elementFinder: elementFinder
            )
        )
    }
}
