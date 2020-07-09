import Foundation
import MixboxTestsFoundation

@objc(PrincipalClass)
final class TestObservationEntryPoint: BaseTestObservationEntryPoint {
    override func main() {
        exportAvailableTestCasesIfNeeded()
        setUpObservation()
    }
    
    private func exportAvailableTestCasesIfNeeded() {
        if let exportPath = env("EMCEE_RUNTIME_TESTS_EXPORT_PATH") {
            TestQuery(outputPath: exportPath).export()
        }
    }
    
    private func setUpObservation() {
        let testFailureRecorder = XcTestFailureRecorder(
            currentTestCaseProvider: AutomaticCurrentTestCaseProvider(),
            shouldNeverContinueTestAfterFailure: false
        )
        
        startObservation(
            testLifecycleManagers: [
                ReportingTestLifecycleManager(
                    reportingSystem: DevNullReportingSystem(),
                    stepLogsProvider: Singletons.stepLogsProvider,
                    stepLogsCleaner: Singletons.stepLogsCleaner,
                    testFailureRecorder: testFailureRecorder
                ),
                MeasureableTimedActivityMetricSenderWaiterTestLifecycleManager()
            ]
        )
    }
    
    private func env(_ envName: String) -> String? {
        guard let value = ProcessInfo.processInfo.environment[envName], !value.isEmpty else {
            return nil
        }
        
        return value
    }
}
