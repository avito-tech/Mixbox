#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

// Replicates instance object of URLProtocol
public protocol BridgedUrlProtocolInstance: AnyObject {
    func startLoading() throws
    func stopLoading() throws
    
    // Not implemented:
    //
    // func property(forKey key: String, in request: URLRequest) -> Any?
    // func setProperty(_ value: Any, forKey key: String, in request: NSMutableURLRequest)
    // func removeProperty(forKey key: String, in request: NSMutableURLRequest)
}

#endif
