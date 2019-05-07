import MixboxIpc

public final class SimulateLocationIpcMethod: IpcMethod {
    public typealias Arguments = Location
    public typealias ReturnValue = IpcVoid
    
    public final class Location: Codable {
        public let latitude: Double
        public let longitude: Double
        
        public init(
            latitude: Double,
            longitude: Double)
        {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    public init() {
    }
}
