#if MIXBOX_ENABLE_IN_APP_SERVICES

// Replicates URLCache.StoragePolicy
public enum BridgedUrlCacheStoragePolicy: String, Codable {
    case allowed
    case allowedInMemoryOnly
    case notAllowed
}

#endif
