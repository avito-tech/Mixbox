#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import MixboxIpc

public final class GetRecordedAssertionFailuresIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let sinceIndex: Int? // pass nil to get all assertions
        
        public init(sinceIndex: Int?) {
            self.sinceIndex = sinceIndex
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = [RecordedAssertionFailure]
    
    public init() {
    }
}

#endif
