public final class NetworkRecordsHolderImpl: NetworkRecordsHolder {
    public private(set) var allRequests: [MonitoredNetworkRequest] = []
    
    public func append(request: MonitoredNetworkRequest) {
        allRequests.append(request)
    }
}
