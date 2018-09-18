// swiftlint:disable empty_count

import MixboxTestsFoundation

public final class XcElementSnapshotCacheSyncronizationImpl: XcElementSnapshotCacheSyncronization {
    // The entry points are in swizzled functions, so I made a singleton:
    static let instance: XcElementSnapshotCacheSyncronization = XcElementSnapshotCacheSyncronizationImpl()
    
    private var knownCaches = Set<WeakXcElementSnapshotCacheBox>()
    private var activeCaches = Set<WeakXcElementSnapshotCacheBox>()
    
    public func dropCaches() {
        forEach(of: &knownCaches) {
            $0.dropCache()
        }
    }
    
    public func use<T>(cache: XcElementSnapshotCache, during: () -> T) -> T {
        // If you want to remove assert, support new cases (where the assert's condition is false).
        assert(activeCaches.count == 0, "activeCaches.count (\(activeCaches.count)) > 0 before using another cache. Probably the scope for cache is too big. Expected usage: usingCache { element.exists }")
        
        XcElementSnapshotCacheSwizzling.instance.swizzleOnce()
        
        let box = WeakXcElementSnapshotCacheBox(cache)
        activeCaches.insert(box)
        knownCaches.insert(box)
        let value = during()
        activeCaches.remove(box)
        return value
    }
    
    public func rootElementSnapshot(calculateValueUsingClosure: () -> (XCElementSnapshot?)) -> XCElementSnapshot? {
        if let cache = activeCaches.first?.value, activeCaches.count == 1 {
            if let value = cache.rootElementSnapshot {
                return value
            } else {
                let value = calculateValueUsingClosure()
                cache.rootElementSnapshot = value?.copy() as? XCElementSnapshot
                return value
            }
        } else {
            return calculateValueUsingClosure()
        }
    }
    
    private func forEach(of caches: inout Set<WeakXcElementSnapshotCacheBox>, do: (XcElementSnapshotCache) -> ()) {
        var needCleanup = false
        
        caches.forEach {
            if let value = $0.value {
                `do`(value)
            } else {
                needCleanup = true
            }
        }
        
        if needCleanup {
            caches = caches.filter { $0.value != nil }
        }
    }
}

private final class WeakXcElementSnapshotCacheBox: Hashable {
    private(set) weak var value: XcElementSnapshotCache?
    
    let hashValue: Int
    private let objectIdentifier: ObjectIdentifier
    
    init(_ value: XcElementSnapshotCache) {
        self.value = value
        self.objectIdentifier = ObjectIdentifier(value)
        self.hashValue = self.objectIdentifier.hashValue
    }
    
    static func ==(l: WeakXcElementSnapshotCacheBox, r: WeakXcElementSnapshotCacheBox) -> Bool {
        return l.objectIdentifier == r.objectIdentifier
    }
}
