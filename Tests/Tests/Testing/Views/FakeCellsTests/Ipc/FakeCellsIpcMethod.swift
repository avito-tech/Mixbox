import MixboxIpc

public final class FakeCellsReloadIpcMethod: IpcMethod {
    public typealias Arguments = FakeCellsReloadType
    public typealias ReturnValue = Int // generation, expect to get 1 after first call
    
    public init() {
    }
}

public final class FakeCellsSubviewsInfoIpcMethod: IpcMethod {
    public final class SubviewInfo: Codable {
        public let accessibilityIdentifier: String?
        public let isHidden: Bool
        
        public init(
            accessibilityIdentifier: String?,
            isHidden: Bool)
        {
            self.accessibilityIdentifier = accessibilityIdentifier
            self.isHidden = isHidden
        }
    }
    
    public typealias Arguments = IpcVoid
    public typealias ReturnValue = [SubviewInfo]
    
    public init() {
    }
}
