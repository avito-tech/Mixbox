#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import Foundation

public protocol UrlRequestNetworkServiceTypeBridging: class {
    func urlRequestNetworkServiceType(
        bridgedUrlRequestNetworkServiceType: BridgedUrlRequestNetworkServiceType)
        throws
        -> URLRequest.NetworkServiceType
    
    func bridgedUrlRequestNetworkServiceType(
        urlRequestNetworkServiceType: URLRequest.NetworkServiceType)
        throws
        -> BridgedUrlRequestNetworkServiceType
}

#endif
