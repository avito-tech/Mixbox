#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class CompoundBridgedUrlProtocolClass:
    BridgedUrlProtocolClass,
    BridgedUrlProtocolClassRepository,
    BridgedUrlProtocolClassForRequestProvider,
    IpcObjectIdentifiable
{
    public let ipcObjectId: IpcObjectId = .uuid
    
    private var bridgedUrlProtocolClasses: [BridgedUrlProtocolClass] = []
    
    public init() {
    }
    
    // MARK: - BridgedUrlProtocolClassRepository
    
    public func add(bridgedUrlProtocolClass: BridgedUrlProtocolClass) {
        bridgedUrlProtocolClasses.append(bridgedUrlProtocolClass)
    }
    
    public func remove(bridgedUrlProtocolClass: BridgedUrlProtocolClass) {
        bridgedUrlProtocolClasses.removeAll {
            $0 === bridgedUrlProtocolClass
        }
    }
    
    // MARK: - BridgedUrlProtocolClass
    
    public func canInit(with request: BridgedUrlRequest) throws -> Bool {
        let bridgedUrlProtocolClass = try bridgedUrlProtocolClassAllowingNilValue(
            forRequest: request
        )
        
        return bridgedUrlProtocolClass != nil
    }
    
    public func canonicalRequest(for request: BridgedUrlRequest) throws -> BridgedUrlRequest {
        let bridgedUrlProtocolClass = try bridgedUrlProtocolClassWithFunctionDescription(
            forRequest: request
        )
        
        return try bridgedUrlProtocolClass.canonicalRequest(for: request)
    }
    
    public func requestIsCacheEquivalent(_ a: BridgedUrlRequest, to b: BridgedUrlRequest) throws -> Bool {
        let bridgedUrlProtocolClass = try bridgedUrlProtocolClassWithFunctionDescription(
            forRequest: a
        )
        
        return try bridgedUrlProtocolClass.requestIsCacheEquivalent(a, to: b)
    }
    
    public func createInstance(
        request: BridgedUrlRequest,
        cachedResponse: BridgedCachedUrlResponse?,
        client: BridgedUrlProtocolClient & IpcObjectIdentifiable)
        throws
        -> BridgedUrlProtocolInstance & IpcObjectIdentifiable
    {
        let bridgedUrlProtocolClass = try bridgedUrlProtocolClassWithFunctionDescription(
            forRequest: request
        )
        
        return try bridgedUrlProtocolClass.createInstance(
            request: request,
            cachedResponse: cachedResponse,
            client: client
        )
    }
    
    // MARK: - BridgedUrlProtocolClassForRequestProvider
    
    public func bridgedUrlProtocolClass(
        forRequest request: BridgedUrlRequest)
        throws
        -> BridgedUrlProtocolClass
    {
        guard let bridgedUrlProtocolClass = try bridgedUrlProtocolClassAllowingNilValue(forRequest: request) else {
            throw ErrorString(
                """
                Did not found bridgedUrlProtocolClass for request \(request) among \
                registered bridgedUrlProtocolClasses: \(bridgedUrlProtocolClasses)
                """
            )
        }
        
        return bridgedUrlProtocolClass
    }
    
    private func bridgedUrlProtocolClassAllowingNilValue(
        forRequest request: BridgedUrlRequest)
        throws
        -> BridgedUrlProtocolClass?
    {
        // Q: Why reversed?
        // A: Last added classes have higher priority.
        for bridgedUrlProtocolClass in bridgedUrlProtocolClasses.reversed() {
            if try bridgedUrlProtocolClass.canInit(with: request) {
                return bridgedUrlProtocolClass
            }
        }
        
        return nil
    }
    
}

#endif
