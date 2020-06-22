#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import Foundation

public protocol UrlRequestBridging: class {
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
