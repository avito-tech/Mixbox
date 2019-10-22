import MixboxIpc

final class HelloIpcMethod: IpcMethod {
    typealias Arguments = IpcVoid
    typealias ReturnValue = String
}
