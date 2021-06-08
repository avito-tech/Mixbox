#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

public protocol UrlRequestBridging: AnyObject {
    func bridgedUrlRequest(
        urlRequest: URLRequest)
        throws
        -> BridgedUrlRequest
    
    func urlRequest(
        bridgedUrlRequest: BridgedUrlRequest)
        throws
        -> URLRequest
}

#endif
