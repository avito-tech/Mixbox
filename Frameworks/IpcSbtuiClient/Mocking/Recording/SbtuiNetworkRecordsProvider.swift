import SBTUITestTunnel
import MixboxUiTestsFoundation

// TODO: Нормально абстрагироваться от SBTMonitoredNetworkRequest
public final class SbtuiNetworkRecordsProvider: NetworkRecordsProvider, NetworkRecorderLifecycle {
    private let tunneledApplication: SBTUITunneledApplication
    
    public init(tunneledApplication: SBTUITunneledApplication) {
        self.tunneledApplication = tunneledApplication
    }
    
    // MARK: - NetworkRecordsProvider
    
    public var allRequests: [MonitoredNetworkRequest] {
        return tunneledApplication.monitoredRequestsPeekAll().map { $0 as MonitoredNetworkRequest }
    }
    
    // MARK: - NetworkRecorderLifecycle
    
    public func startRecording() {
        _ = tunneledApplication.monitorRequests(
            matching: SBTRequestMatch(url: ".*")
        )
    }
    
    public func stopRecording() {
        tunneledApplication.monitorRequestRemoveAll()
    }
}

extension SBTMonitoredNetworkRequest: MonitoredNetworkRequest {
    public func requestJson() -> [String : Any]? {
        return requestJSON() as? [String : Any]
    }
    
    public func responseJson() -> [String : Any]? {
        return responseJSON() as? [String : Any]
    }
}
