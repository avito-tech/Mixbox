public protocol SnapshotCaches {
    var application: XcElementSnapshotCache { get }
    var descendantsFromRoot: XcElementSnapshotCache { get }
}

public final class SnapshotCachesImpl: SnapshotCaches {
    public let application: XcElementSnapshotCache
    public let descendantsFromRoot: XcElementSnapshotCache
    
    public init(
        application: XcElementSnapshotCache,
        descendantsFromRoot: XcElementSnapshotCache)
    {
        self.application = application
        self.descendantsFromRoot = descendantsFromRoot
    }
    
    public static func create(cachingEnabled: Bool) -> SnapshotCachesImpl {
        return SnapshotCachesImpl(
            application: create(cachingEnabled: cachingEnabled),
            descendantsFromRoot: create(cachingEnabled: cachingEnabled)
        )
    }
        
    private static func create(cachingEnabled: Bool) -> XcElementSnapshotCache {
        if cachingEnabled {
            return XcElementSnapshotCacheImpl(
                syncronization: XcElementSnapshotCacheSyncronizationImpl.instance
            )
        } else {
            return DisabledXcElementSnapshotCache()
        }
    }
}
