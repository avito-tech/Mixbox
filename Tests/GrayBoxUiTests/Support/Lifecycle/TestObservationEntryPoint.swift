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
        guard let artifactStorage = self.artifactStorage() else {
            return
        }
        
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
