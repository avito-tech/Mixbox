import MixboxFoundation
import MixboxTestsFoundation

// swiftlint:disable missing_spaces_after_colon

final class SwizzlingOfXCUIElementForDroppingCache: Swizzling {
    private let swizzler: AssertingSwizzler
    
    init(swizzler: AssertingSwizzler) {
        self.swizzler = swizzler
    }
    
    func swizzle() {
        swizzler.swizzle(
            XCUIElement.self,
            #selector(XCUIElement.tap as (XCUIElement) -> () -> ()),
            #selector(XCUIElement.swizzled_tap as (XCUIElement) -> () -> ()),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUIElement.self,
            #selector(XCUIElement.doubleTap),
            #selector(XCUIElement.swizzled_doubleTap),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUIElement.self,
            #selector(XCUIElement.twoFingerTap),
            #selector(XCUIElement.swizzled_twoFingerTap),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUIElement.self,
            #selector(XCUIElement.tap(withNumberOfTaps:numberOfTouches:)),
            #selector(XCUIElement.swizzled_tap(withNumberOfTaps:numberOfTouches:)),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUIElement.self,
            #selector(XCUIElement.press(forDuration:)),
            #selector(XCUIElement.swizzled_press(forDuration:)),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUIElement.self,
            #selector(XCUIElement.press(forDuration:thenDragTo:)),
            #selector(XCUIElement.swizzled_press(forDuration:thenDragTo:)),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUIElement.self,
            #selector(XCUIElement.swipeUp),
            #selector(XCUIElement.swizzled_swipeUp),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUIElement.self,
            #selector(XCUIElement.swipeDown),
            #selector(XCUIElement.swizzled_swipeDown),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUIElement.self,
            #selector(XCUIElement.swipeLeft),
            #selector(XCUIElement.swizzled_swipeLeft),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUIElement.self,
            #selector(XCUIElement.swipeRight),
            #selector(XCUIElement.swizzled_swipeRight),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUIElement.self,
            #selector(XCUIElement.pinch(withScale:velocity:)),
            #selector(XCUIElement.swizzled_pinch(withScale:velocity:)),
            .instanceMethod
        )
        swizzler.swizzle(
            XCUIElement.self,
            #selector(XCUIElement.rotate(_:withVelocity:)),
            #selector(XCUIElement.swizzled_rotate(_:withVelocity:)),
            .instanceMethod
        )
    }
}

private extension XCUIElement {
    @objc func swizzled_tap() {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_tap()
    }
    @objc func swizzled_doubleTap() {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_doubleTap()
    }
    @objc func swizzled_twoFingerTap() {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_twoFingerTap()
    }
    @objc func swizzled_tap(withNumberOfTaps numberOfTaps: Int, numberOfTouches: Int) {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_tap(withNumberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches)
    }
    @objc func swizzled_press(forDuration duration: TimeInterval) {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_press(forDuration: duration)
    }
    @objc func swizzled_press(forDuration duration: TimeInterval, thenDragTo otherElement: XCUIElement) {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_press(forDuration: duration, thenDragTo: otherElement)
    }
    @objc func swizzled_swipeUp() {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_swipeUp()
    }
    @objc func swizzled_swipeDown() {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_swipeDown()
    }
    @objc func swizzled_swipeLeft() {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_swipeLeft()
    }
    @objc func swizzled_swipeRight() {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_swipeRight()
    }
    @objc func swizzled_pinch(withScale scale: CGFloat, velocity: CGFloat) {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_pinch(withScale: scale, velocity: velocity)
    }
    @objc func swizzled_rotate(_ rotation: CGFloat, withVelocity velocity: CGFloat) {
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
        return swizzled_rotate(rotation, withVelocity: velocity)
    }
}
