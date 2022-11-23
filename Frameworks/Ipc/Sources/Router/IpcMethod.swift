#if MIXBOX_ENABLE_FRAMEWORK_IPC && MIXBOX_DISABLE_FRAMEWORK_IPC
#error("Ipc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC)
// The compilation is disabled
#else

// Defines an intrface for communication between processes.
// You can share your defined methods between projects (e.g. via shared library)
//
// Example for a method without arguments returning a number:
//
// public final class GetAnswerToUltimateQuestionIpcMethod: IpcMethod {
//     typealias Arguments = IpcVoid
//     typealias ReturnValue = Int
// }
//
public protocol IpcMethod: AnyObject {
    associatedtype Arguments: Codable
    associatedtype ReturnValue: Codable
    
    var name: String { get }
}

public extension IpcMethod {
    var name: String {
        return "\(type(of: self))"
    }
}

#endif
