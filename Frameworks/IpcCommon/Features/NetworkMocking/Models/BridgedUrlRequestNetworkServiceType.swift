#if MIXBOX_ENABLE_IN_APP_SERVICES

// Replicates NetworkServiceType
public enum BridgedUrlRequestNetworkServiceType: String, Codable {
    case `default` // Standard internet traffic
    case voip // Voice over IP control traffic
    case video // Video traffic
    case background // Background traffic
    case voice // Voice data
    case responsiveData // Responsive data
    case callSignaling // Call Signaling
    
    // Intruduced in Xcode 11. Not defined in Xcode 10.3.
    // case avStreaming // Multimedia Audio/Video Streaming
    // case responsiveAV // Responsive Multimedia Audio/Video
}

#endif
