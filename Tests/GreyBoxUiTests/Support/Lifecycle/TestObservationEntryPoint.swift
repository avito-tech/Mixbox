import Foundation
import MixboxTestsFoundation
import MixboxAllure
import MixboxArtifacts

@objc(PrincipalClass)
final class TestObservationEntryPoint: BaseTestObservationEntryPoint {
    override func main() {
        setUpObservation()
    }
    
    private func setUpObservation() {
        let allureReportsDirectoryEnv = ProcessInfo.processInfo.environment["MIXBOX_CI_ALLURE_REPORTS_DIRECTORY"]
        guard let allureReportsDirectory = allureReportsDirectoryEnv, !allureReportsDirectory.isEmpty else {
            return
        }
        
        let testFailureRecorder = XcTestFailureRecorder(
            currentTestCaseProvider: AutomaticCurrentTestCaseProvider()
        )
        
        let reportingTestLifecycleManager = ReportingTestLifecycleManager(
            reportingSystem: AllureReportingSystem(
                allureResultsStorage: AllureResultsStorageImpl(
                    artifactStorage: ArtifactStorageImpl(
                        artifactsRootDirectory: allureReportsDirectory
                    )
                )
            ),
            stepLogsProvider: Singletons.stepLogsProvider,
            testFailureRecorder: testFailureRecorder
        )
        
        startObservation(
            testLifecycleManagers: [
                reportingTestLifecycleManager
            ]
        )
    }
}
