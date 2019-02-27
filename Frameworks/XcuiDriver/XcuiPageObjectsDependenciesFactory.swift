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
    private let elementFinder: ElementFinder
    private let applicationProvider: ApplicationProvider
    private let applicationCoordinatesProvider: ApplicationCoordinatesProvider
    private let eventGenerator: EventGenerator
    
    public init(
        interactionExecutionLogger: InteractionExecutionLogger,
        testFailureRecorder: TestFailureRecorder,
        ipcClient: IpcClient,
        snapshotsComparisonUtility: SnapshotsComparisonUtility,
        stepLogger: StepLogger,
        pollingConfiguration: PollingConfiguration,
        elementFinder: ElementFinder,
        applicationProvider: ApplicationProvider,
        applicationCoordinatesProvider: ApplicationCoordinatesProvider,
        eventGenerator: EventGenerator)
    {
        self.interactionExecutionLogger = interactionExecutionLogger
        self.testFailureRecorder = testFailureRecorder
        self.ipcClient = ipcClient
        self.snapshotsComparisonUtility = snapshotsComparisonUtility
        self.stepLogger = stepLogger
        self.pollingConfiguration = pollingConfiguration
        self.elementFinder = elementFinder
        self.applicationProvider = applicationProvider
        self.applicationCoordinatesProvider = applicationCoordinatesProvider
        self.eventGenerator = eventGenerator
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
                elementFinder: elementFinder,
                applicationProvider: applicationProvider,
                applicationCoordinatesProvider: applicationCoordinatesProvider,
                eventGenerator: eventGenerator
            )
        )
    }
    
    public func matcherBuilder() -> ElementMatcherBuilder {
        return ElementMatcherBuilder(snapshotsComparisonUtitlity: snapshotsComparisonUtility)
    }
}
