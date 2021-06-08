#if MIXBOX_ENABLE_IN_APP_SERVICES

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
