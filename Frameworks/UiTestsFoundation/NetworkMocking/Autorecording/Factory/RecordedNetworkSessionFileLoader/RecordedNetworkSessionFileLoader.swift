public protocol RecordedNetworkSessionFileLoader {
    func recordedNetworkSession(path: String) throws -> RecordedNetworkSession
}
