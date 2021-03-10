import MixboxIpcCommon
import MixboxIpc
import MixboxFoundation

public final class IpcBridgedUrlProtocolClient: BridgedUrlProtocolClient, IpcObjectIdentifiable {
    public let ipcObjectId: IpcObjectId
    
    private let ipcClient: SynchronousIpcClient
    
    public init(
        ipcObjectId: IpcObjectId,
        ipcClient: SynchronousIpcClient)
    {
        self.ipcObjectId = ipcObjectId
        self.ipcClient = ipcClient
    }
    
    public func urlProtocolWasRedirectedTo(
        request: BridgedUrlRequest,
        redirectResponse: BridgedUrlResponse)
        throws
    {
        try call(
            method: UrlProtocolWasRedirectedToIpcMethod(),
            arguments: UrlProtocolWasRedirectedToIpcMethod.Arguments(
                selfIpcObjectId: ipcObjectId,
                bridgedUrlRequest: request,
                redirectBridgedUrlResponse: redirectResponse
            )
        )
    }
    
    public func urlProtocolCachedResponseIsValid(
        cachedResponse: BridgedCachedUrlResponse)
        throws
    {
        try call(
            method: UrlProtocolCachedResponseIsValidIpcMethod(),
            arguments: UrlProtocolCachedResponseIsValidIpcMethod.Arguments(
                selfIpcObjectId: ipcObjectId,
                bridgedCachedUrlResponse: cachedResponse
            )
        )
    }
    
    public func urlProtocolDidReceive(
        response: BridgedUrlResponse,
        cacheStoragePolicy: BridgedUrlCacheStoragePolicy)
        throws
    {
        try call(
            method: UrlProtocolDidReceiveIpcMethod(),
            arguments: UrlProtocolDidReceiveIpcMethod.Arguments(
                selfIpcObjectId: ipcObjectId,
                bridgedUrlResponse: response,
                bridgedUrlCacheStoragePolicy: cacheStoragePolicy
            )
        )
    }
    
    public func urlProtocolDidLoad(
        data: Data)
        throws
    {
        try call(
            method: UrlProtocolDidLoadIpcMethod(),
            arguments: UrlProtocolDidLoadIpcMethod.Arguments(
                selfIpcObjectId: ipcObjectId,
                data: data
            )
        )
    }
    
    public func urlProtocolDidFailWithError(
        error: String)
        throws
    {
        try call(
            method: UrlProtocolDidFailWithErrorIpcMethod(),
            arguments: UrlProtocolDidFailWithErrorIpcMethod.Arguments(
                selfIpcObjectId: ipcObjectId,
                error: error
            )
        )
    }
    
    public func urlProtocolDidFinishLoading()
        throws
    {
        try call(
            method: UrlProtocolDidFinishLoadingIpcMethod(),
            arguments: UrlProtocolDidFinishLoadingIpcMethod.Arguments(
                selfIpcObjectId: ipcObjectId
            )
        )
    }
    
    private func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments)
        throws
    {
        let result: DataResult<Method.ReturnValue, Error> = ipcClient.call(
            method: method,
            arguments: arguments
        )
        
        switch result {
        case .data:
            break
        case .error(let error):
            throw error
        }
    }
}
