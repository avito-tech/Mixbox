import MixboxTestsFoundation

public final class XcElementSnapshotCacheImpl: XcElementSnapshotCache {
    private let syncronization: XcElementSnapshotCacheSyncronization
    public var rootElementSnapshot: XCElementSnapshot?
    
    public init(syncronization: XcElementSnapshotCacheSyncronization) {
        self.syncronization = syncronization
    }
    
    public func dropCache() {
        rootElementSnapshot = nil
    }
    
    public func use<T>(_ during: () -> (T)) -> T {
        return syncronization.use(cache: self, during: during)
    }
}
