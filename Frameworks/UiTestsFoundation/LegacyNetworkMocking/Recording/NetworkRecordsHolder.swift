public protocol NetworkRecordsHolder: NetworkRecordsProvider {
    func append(request: MonitoredNetworkRequest)
}
