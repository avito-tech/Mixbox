#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxFoundation

public final class GetUiEventHistoryIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let sinceDate: Date
        
        public init(sinceDate: Date) {
            self.sinceDate = sinceDate
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = IpcThrowingFunctionResult<UiEventHistory>
    
    public init() {
    }
}

#endif
