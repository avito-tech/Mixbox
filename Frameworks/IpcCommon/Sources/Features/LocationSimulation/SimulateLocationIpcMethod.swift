#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

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

#endif
