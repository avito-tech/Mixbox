#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import MixboxFoundation

public final class UrlRequestNetworkServiceTypeBridgingImpl: UrlRequestNetworkServiceTypeBridging {
    public init() {
    }
    
    public func urlRequestNetworkServiceType(
        bridgedUrlRequestNetworkServiceType: BridgedUrlRequestNetworkServiceType)
        throws
        -> URLRequest.NetworkServiceType
    {
        switch bridgedUrlRequestNetworkServiceType {
        case .`default`:
            return .`default`
        case .voip:
            return .voip
        case .video:
            return .video
        case .background:
            return .background
        case .voice:
            return .voice
        case .responsiveData:
            return .responsiveData
        case .callSignaling:
            if #available(iOS 10.0, *) {
                return .callSignaling
            } else {
                throw ErrorString(
                    """
                    Can not bridge BridgedUrlRequestNetworkServiceType to URLRequest.NetworkServiceType: \
                    callSignaling case of URLRequest.NetworkServiceType is not available on iOS below 10.0.
                    """
                )
            }
        default:
            break
        }
    }
    
    public func bridgedUrlRequestNetworkServiceType(
        urlRequestNetworkServiceType: URLRequest.NetworkServiceType)
        throws
        -> BridgedUrlRequestNetworkServiceType
    {
        switch urlRequestNetworkServiceType {
        case .`default`:
            return .`default`
        case .voip:
            return .voip
        case .video:
            return .video
        case .background:
            return .background
        case .voice:
            return .voice
        case .responsiveData:
            return .responsiveData
        case .callSignaling:
            return .callSignaling
        default:
            throw ErrorString("Unsupported URLRequest.NetworkServiceType: \(urlRequestNetworkServiceType)")
        }
    }
}

#endif
