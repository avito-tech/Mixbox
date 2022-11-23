#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import Foundation

public final class UiEventHistory: Codable {
    public let uiEventHistoryRecords: [UiEventHistoryRecord]
    public let startDate: Date
    public let stopDate: Date
    
    public init(
        uiEventHistoryRecords: [UiEventHistoryRecord],
        startDate: Date,
        stopDate: Date)
    {
        self.uiEventHistoryRecords = uiEventHistoryRecords
        self.startDate = startDate
        self.stopDate = stopDate
    }
}

#endif
