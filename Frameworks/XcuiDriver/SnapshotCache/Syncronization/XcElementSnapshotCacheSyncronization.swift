import MixboxFoundation
import MixboxTestsFoundation

public protocol XcElementSnapshotCacheSyncronization {
    func use<T>(cache: XcElementSnapshotCache, during: () -> T) -> T
    
    // Called from swizzled funcs and maybe other code
    func dropCaches()
    func rootElementSnapshot(calculateValueUsingClosure: () -> (XCElementSnapshot?)) -> XCElementSnapshot?
}
