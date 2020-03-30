import MixboxIpc

public final class SetScreenIpcMethod: IpcMethod {
    public final class Screen: Codable {
        public let viewType: String
        
        public init(
            viewType: String)
        {
            self.viewType = viewType
        }
    }
    
    public typealias Arguments = Screen?
    public typealias ReturnValue = IpcVoid
    
    public init() {
    }
}
