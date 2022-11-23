#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

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
