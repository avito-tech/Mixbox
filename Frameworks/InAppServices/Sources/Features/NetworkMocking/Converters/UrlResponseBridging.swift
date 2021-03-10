#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

public protocol UrlResponseBridging: class {
    func urlResponse(bridgedUrlResponse: BridgedUrlResponse)
        throws
        -> URLResponse
    
    func bridgedUrlResponse(urlResponse: URLResponse)
        throws
        -> BridgedUrlResponse
}

#endif
