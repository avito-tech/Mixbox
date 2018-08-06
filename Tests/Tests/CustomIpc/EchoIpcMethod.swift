import MixboxIpc

final class EchoIpcMethod<T: Codable>: IpcMethod {
    typealias Arguments = T
    typealias ReturnValue = T
}
