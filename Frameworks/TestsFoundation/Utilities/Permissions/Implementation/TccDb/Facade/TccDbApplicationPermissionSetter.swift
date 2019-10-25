import MixboxTestsFoundation
import MixboxFoundation

public final class TccDbApplicationPermissionSetter: ApplicationPermissionSetter {
    private let service: TccService
    private let testFailureRecorder: TestFailureRecorder
    private let tccPrivacySettingsManager: TccPrivacySettingsManager
    
    public init(
        service: TccService,
        testFailureRecorder: TestFailureRecorder,
        tccPrivacySettingsManager: TccPrivacySettingsManager)
    {
        self.service = service
        self.testFailureRecorder = testFailureRecorder
        self.tccPrivacySettingsManager = tccPrivacySettingsManager
    }
    
    public func set(_ state: AllowedDeniedNotDeterminedState) {
        do {
            try tccPrivacySettingsManager.updatePrivacySettings(
                service: service,
                state: tccServicePrivacyState(state: state)
            )
        } catch {
            testFailureRecorder.recordFailure(
                description: "Не удалось пропатчить настройки приватности: \(error)",
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
