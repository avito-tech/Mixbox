import Foundation
import MixboxTestsFoundation
import MixboxAllure
import MixboxArtifacts

@objc(PrincipalClass)
final class TestObservationEntryPoint: BaseTestObservationEntryPoint {
    override func main() {
        exportAvailableTestCasesIfNeeded()
        setUpObservation()
    }
    
    private func exportAvailableTestCasesIfNeeded() {
        // TODO: Get rid of usage of ProcessInfo singleton here
        let exportPath: String? = ProcessInfo.processInfo.environment["AVITO_TEST_RUNNER_RUNTIME_TESTS_EXPORT_PATH"]
        
        if let exportPath = exportPath, !exportPath.isEmpty {
            TestQuery(outputPath: exportPath).export()
        }
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
