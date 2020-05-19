#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

// TODO: Rename everywhere
// TODO: Replace `DataResult` with plain Swift errors (try/catch)?
public typealias IpcClientError = Error

// TODO: Maybe to use other protocol everywhere where `IpcClient` is used. The protocol that can connect to remote
// process and wait for connection. Because at the moment there are places where LazilyInitializedIpcClient is
// used. And tests are failed if nested `ipcClient` is nil. But this feature (`LazilyInitializedIpcClient`) will be
// needed inside tested application (to inject IpcClient in method handlers and wait for connection automatically).
public protocol IpcClient: class {
    func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, IpcClientError>) -> ())
}

#endif
