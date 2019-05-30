public protocol RecordedNetworkSessionFileLoader: class {
    func recordedNetworkSession(path: String) throws -> RecordedNetworkSession
}
