#if MIXBOX_ENABLE_FRAMEWORK_IPC && MIXBOX_DISABLE_FRAMEWORK_IPC
#error("Ipc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC)
// The compilation is disabled
#else

import MixboxFoundation

// TODO: Rename everywhere
// TODO: Replace `DataResult` with plain Swift errors (try/catch)?
public typealias IpcClientError = Error

// TODO: Maybe to use other protocol everywhere where `IpcClient` is used. The protocol that can connect to remote
// process and wait for connection. Because at the moment there are places where LazilyInitializedIpcClient is
// used. And tests are failed if nested `ipcClient` is nil. But this feature (`LazilyInitializedIpcClient`) will be
// needed inside tested application (to inject IpcClient in method handlers and wait for connection automatically).
public protocol IpcClient: AnyObject {
    func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, IpcClientError>) -> ())
}

#endif
