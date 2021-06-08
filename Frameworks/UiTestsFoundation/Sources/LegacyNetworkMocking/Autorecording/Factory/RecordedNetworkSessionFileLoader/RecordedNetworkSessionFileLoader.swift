public protocol RecordedNetworkSessionFileLoader: AnyObject {
    func recordedNetworkSession(path: String) throws -> RecordedNetworkSession
}
