import MixboxUiTestsFoundation

public final class GrayApplicationStateProvider: ApplicationStateProvider {
    public init() {
    }
    
    public func applicationState() throws -> ApplicationState {
        return .runningForeground
    }
}
