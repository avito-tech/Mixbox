#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

// Replicates class object of URLProtocol
//
// For registering classes, see BridgedUrlProtocolRegisterer
//
public protocol BridgedUrlProtocolClass: AnyObject {
    func canInit(with request: BridgedUrlRequest) throws -> Bool
    func canonicalRequest(for request: BridgedUrlRequest) throws -> BridgedUrlRequest
    func requestIsCacheEquivalent(_ a: BridgedUrlRequest, to b: BridgedUrlRequest) throws -> Bool
    
    // init of URLProtocol
    func createInstance(
        request: BridgedUrlRequest,
        cachedResponse: BridgedCachedUrlResponse?,
        client: BridgedUrlProtocolClient & IpcObjectIdentifiable)
        throws
        -> BridgedUrlProtocolInstance & IpcObjectIdentifiable
}

#endif
