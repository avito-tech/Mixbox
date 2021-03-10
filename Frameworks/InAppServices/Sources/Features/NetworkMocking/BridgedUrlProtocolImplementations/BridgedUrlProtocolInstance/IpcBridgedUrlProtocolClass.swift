#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

// The only responsibility of this class is to access `BridgedUrlProtocolClass` via IPC.
public final class IpcBridgedUrlProtocolClass: BridgedUrlProtocolClass, IpcObjectIdentifiable {
    public let ipcObjectId: IpcObjectId
    
    private let ipcClient: SynchronousIpcClient
    private let writeableClientsRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolClient & IpcObjectIdentifiable>
    
    public init(
        ipcObjectId: IpcObjectId,
        ipcClient: SynchronousIpcClient,
        writeableClientsRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolClient & IpcObjectIdentifiable>)
    {
        self.ipcObjectId = ipcObjectId
        self.ipcClient = ipcClient
        self.writeableClientsRepository = writeableClientsRepository
    }
    
    public func canInit(
        with request: BridgedUrlRequest)
        throws
        -> Bool
    {
        let result = try ipcClient.callOrThrow(
            method: UrlProtocolCanInitIpcMethod(),
            arguments: UrlProtocolCanInitIpcMethod.Arguments(
                selfIpcObjectId: ipcObjectId,
                bridgedUrlRequest: request
            )
        )
        
        return try result.getReturnValue()
    }
    
    public func canonicalRequest(
        for request: BridgedUrlRequest)
        throws
        -> BridgedUrlRequest
    {
        let result = try ipcClient.callOrThrow(
            method: UrlProtocolCanonicalRequestIpcMethod(),
            arguments: UrlProtocolCanonicalRequestIpcMethod.Arguments(
                selfIpcObjectId: ipcObjectId,
                bridgedUrlRequest: request
            )
        )
        
        return try result.getReturnValue()
    }
    
    public func requestIsCacheEquivalent(
        _ lhsRequest: BridgedUrlRequest,
        to rhsRequest: BridgedUrlRequest)
        throws
        -> Bool
    {
        let result = try ipcClient.callOrThrow(
            method: UrlProtocolRequestIsCacheEquivalentIpcMethod(),
            arguments: UrlProtocolRequestIsCacheEquivalentIpcMethod.Arguments(
                selfIpcObjectId: ipcObjectId,
                lhsRequest: lhsRequest,
                rhsRequest: rhsRequest
            )
        )
        
        return try result.getReturnValue()
    }
    
    public func createInstance(
        request: BridgedUrlRequest,
        cachedResponse: BridgedCachedUrlResponse?,
        client: BridgedUrlProtocolClient & IpcObjectIdentifiable)
        throws
        -> BridgedUrlProtocolInstance & IpcObjectIdentifiable
    {
        let clientIpcObjectId: IpcObjectId = client.ipcObjectId
        
        _ = writeableClientsRepository.insert(
            object: client,
            ipcObjectId: clientIpcObjectId
        )
        
        let result = try ipcClient.callOrThrow(
            method: UrlProtocolCreateInstanceIpcMethod(),
            arguments: UrlProtocolCreateInstanceIpcMethod.Arguments(
                selfIpcObjectId: ipcObjectId,
                bridgedUrlRequest: request,
                bridgedCachedUrlResponse: cachedResponse,
                bridgedUrlProtocolClientIpcObjectId: clientIpcObjectId
            )
        )
        
        let instanceIpcObjectId = try result.getReturnValue()
        
        return IpcBridgedUrlProtocolInstance(
            ipcObjectId: instanceIpcObjectId,
            ipcClient: ipcClient
        )
    }
    
}

#endif
