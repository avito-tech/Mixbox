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
        guard let artifactStorage = self.artifactStorage() else {
            return
        }
        
        let testFailureRecorder = XcTestFailureRecorder(
            currentTestCaseProvider: AutomaticCurrentTestCaseProvider()
        )
        
        let reportingTestLifecycleManager = ReportingTestLifecycleManager(
            reportingSystem: AllureReportingSystem(
                allureResultsStorage: AllureResultsStorageImpl(
                    artifactStorage: artifactStorage
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
    
    private func artifactStorage() -> ArtifactStorage? {
        if let storage = localArtifactStorage() {
            return storage
        }
        
        return nil
    }
    
    private func localArtifactStorage() -> ArtifactStorage? {
        guard let directory = env("MIXBOX_CI_ALLURE_REPORTS_DIRECTORY") else {
            return nil
        }
        
        return LocalArtifactStorage(artifactsRootDirectory: directory)
    }
    
    private func env(_ envName: String) -> String? {
        guard let value = ProcessInfo.processInfo.environment[envName], !value.isEmpty else {
            return nil
        }
        
        return value
    }
}
