#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
            throw UnsupportedEnumCaseError(urlRequestNetworkServiceType)
        }
    }
}

#endif
