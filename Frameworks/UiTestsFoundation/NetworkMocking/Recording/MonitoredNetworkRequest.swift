// Not really a good abstraction. It duplicates SBTMonitoredNetworkRequest interface.
public protocol MonitoredNetworkRequest {
    func requestJson() -> [String: Any]?
    func requestString() -> String?
    func responseJson() -> [String: Any]?
    func responseString() -> String?
    var isRewritten: Bool { get }
    var isStubbed: Bool { get }
    var originalRequest: URLRequest? { get }
    var request: URLRequest? { get }
    var requestTime: TimeInterval { get }
    var response: HTTPURLResponse? { get }
    var responseData: Data? { get }
    var timestamp: TimeInterval { get }
}
