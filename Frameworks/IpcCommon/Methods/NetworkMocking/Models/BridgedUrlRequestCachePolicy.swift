#if MIXBOX_ENABLE_IN_APP_SERVICES

// Replicates URLRequest.CachePolicy
public enum BridgedUrlRequestCachePolicy: String, Codable {
    case useProtocolCachePolicy
    case reloadIgnoringLocalCacheData
    case reloadIgnoringLocalAndRemoteCacheData
    case returnCacheDataElseLoad
    case returnCacheDataDontLoad
    case reloadRevalidatingCacheData
}

#endif
