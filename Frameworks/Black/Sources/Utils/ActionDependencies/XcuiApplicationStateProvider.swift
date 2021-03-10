import MixboxUiTestsFoundation
import MixboxFoundation

public final class XcuiApplicationStateProvider: ApplicationStateProvider {
    private let applicationProvider: ApplicationProvider
    
    public init(applicationProvider: ApplicationProvider) {
        self.applicationProvider = applicationProvider
    }
    
    public func applicationState() throws -> ApplicationState {
        let state = applicationProvider.application.state
        switch state {
        case .unknown:
            return .unknown
        case .notRunning:
            return .notRunning
        case .runningBackgroundSuspended:
            return .runningBackgroundSuspended
        case .runningBackground:
            return .runningBackground
        case .runningForeground:
            return .runningForeground
        @unknown default:
            throw UnsupportedEnumCaseError(state)
        }
    }
}
