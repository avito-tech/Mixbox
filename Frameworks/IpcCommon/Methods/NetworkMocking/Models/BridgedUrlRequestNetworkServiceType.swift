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
}

#endif
