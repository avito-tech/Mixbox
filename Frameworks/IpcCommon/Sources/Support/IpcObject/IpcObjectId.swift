#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import UIKit

// TODO: Clean-up automatically (on deinit)
// TODO: Type-erased identifier? (Hashable/Codable; e.g. AnyHashable & AnyCodable)
public final class IpcObjectId: Codable, Hashable {
    public let string: String
    
    public init(string: String) {
        self.string = string
    }
    
    public static var uuid: IpcObjectId {
        return IpcObjectId(string: UUID().uuidString)
    }
    
    public static func ==(lhs: IpcObjectId, rhs: IpcObjectId) -> Bool {
        return lhs.string == rhs.string
    }
    
    public func hash(into hasher: inout Hasher) {
        string.hash(into: &hasher)
    }
}

#endif
