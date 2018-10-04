import MixboxIpc
import MixboxBuiltinIpc

// Used for testing IpcCallback
//
// Contract:
//
// input: T (x), IpcCallback T (y) -> U (z)
// output: (z), result of call to callback with y = x
//
// Example: if you pass 42 and { $0 / 2 }, then you will receive 21
//
final class CallbackToAppIpcMethod<T: Codable, U: Codable>: IpcMethod {
    typealias Arguments = CallbackToAppIpcMethodArguments<T, U>
    typealias ReturnValue = U?
}

final class CallbackToAppIpcMethodArguments<T: Codable, U: Codable>: Codable {
    let value: T
    let callback: IpcCallback<T, U?>
    
    init(
        value: T,
        callback: IpcCallback<T, U?>)
    {
        self.value = value
        self.callback = callback
    }
}
