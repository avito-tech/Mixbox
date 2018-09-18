import MixboxReporting
import MixboxFoundation

public final class TccDbApplicationPermissionSetter: ApplicationPermissionSetter {
    private let tccPrivacySettingsManager: TccPrivacySettingsManager
    private let service: TccService
    private let testFailureRecorder: TestFailureRecorder
    
    public init(service: TccService, bundleId: String, testFailureRecorder: TestFailureRecorder) {
        tccPrivacySettingsManager = TccPrivacySettingsManager(
            bundleId: bundleId
        )
        self.service = service
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func set(_ state: AllowedDeniedNotDeterminedState) {
        let success = tccPrivacySettingsManager.updatePrivacySettings(
            service: service,
            state: tccServicePrivacyState(state: state)
        )
        
        if !success {
            testFailureRecorder.recordFailure(
                description: "Не удалось пропатчить настройки приватности",
                shouldContinueTest: false
            )
        }
    }
    
    private func tccServicePrivacyState(state: AllowedDeniedNotDeterminedState) -> TccServicePrivacyState {
        switch state {
        case .allowed:
            return .allowed
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        }
    }
}
