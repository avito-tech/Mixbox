#if MIXBOX_ENABLE_IN_APP_SERVICES

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
public protocol IpcMethod: class {
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
