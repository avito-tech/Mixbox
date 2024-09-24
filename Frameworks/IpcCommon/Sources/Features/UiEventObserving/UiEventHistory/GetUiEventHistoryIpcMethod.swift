#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import MixboxIpc
import MixboxFoundation
import Foundation

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
