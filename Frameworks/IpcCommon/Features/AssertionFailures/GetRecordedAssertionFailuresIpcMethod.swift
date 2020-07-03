#if MIXBOX_ENABLE_IN_APP_SERVICES

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
