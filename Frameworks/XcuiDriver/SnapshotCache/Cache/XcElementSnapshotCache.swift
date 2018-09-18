import MixboxTestsFoundation

// Note that root element can differ for different requests and you may want to use different caches.
//
// Example of usage:
//
// return cache.usingCache { xcuiElement.exists }
//
// You should wrap any call to XCUIElement or XCUICoordinate if you want to use caching.
//
public protocol XcElementSnapshotCache: class {
    var rootElementSnapshot: XCElementSnapshot? { get set }
    func dropCache()
    func use<T>(_ during: () -> (T)) -> T
}
