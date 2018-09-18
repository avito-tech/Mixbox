import MixboxTestsFoundation

public final class DisabledXcElementSnapshotCache: XcElementSnapshotCache {
    public var rootElementSnapshot: XCElementSnapshot?
    
    public init() {
    }
    
    public func dropCache() {
    }
    
    public func use<T>(_ during: () -> (T)) -> T {
        return during()
    }
}
