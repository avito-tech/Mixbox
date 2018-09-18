import MixboxFoundation
import MixboxTestsFoundation

// swiftlint:disable missing_spaces_after_colon

final class SwizzlingOfXCUICoordinateForDroppingCache: Swizzling {
    private let swizzler: AssertingSwizzler
    
    init(swizzler: AssertingSwizzler) {
        self.swizzler = swizzler
    }
    
    func swizzle() {
        swizzler.swizzle(
            XCUICoordinate.self,
            #selector(XCUICoordinate.tap),
            #selector(XCUICoordinate.swizzled_tap),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUICoordinate.self,
            #selector(XCUICoordinate.doubleTap),
            #selector(XCUICoordinate.swizzled_doubleTap),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUICoordinate.self,
            #selector(XCUICoordinate.press(forDuration:)),
            #selector(XCUICoordinate.swizzled_press(forDuration:)),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUICoordinate.self,
            #selector(XCUICoordinate.press(forDuration:thenDragTo:)),
            #selector(XCUICoordinate.swizzled_press(forDuration:thenDragToCoordinate:)),
            .instanceMethod
        )
    }
}

private extension XCUICoordinate {
    @objc func swizzled_tap() {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_tap()
    }
    @objc func swizzled_doubleTap() {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_doubleTap()
    }
    @objc func swizzled_press(forDuration duration: TimeInterval) {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_press(forDuration: duration)
    }
    @objc func swizzled_press(forDuration duration: TimeInterval, thenDragToCoordinate otherCoordinate: XCUICoordinate) {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_press(forDuration: duration, thenDragToCoordinate: otherCoordinate)
    }
}
