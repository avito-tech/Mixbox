public final class IpcTestingViewConfiguration: Codable {
    public let views: [IpcView]
    
    public init(
        views: [IpcView])
    {
        self.views = views
    }
}
