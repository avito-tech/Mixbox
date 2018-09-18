import MixboxTestsFoundation

public extension XCUIApplication {
    func tappableCoordinate(point: CGPoint) -> XCUICoordinate {
        return tappableCoordinate(x: point.x, y: point.y)
    }
    
    func tappableCoordinate(x: CGFloat, y: CGFloat) -> XCUICoordinate {
        // If you try to create XCUICoordinate from XCUIApplication, with absolute offset from normalized offset {0, 0}
        // that is greater or equals screen size at least at one axis and none of coordinates are negative,
        // then coordinates will be kindly divided by 2 for you by XCUI.
        //
        // This logic is very funny:
        //
        // if (x > 0 && y > 0 && (x >= maxX || y >= maxY) {
        //     x /= 2
        //     y /= 2
        // }
        //
        // po XCUIApplication().coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: 10, dy: 1000)).screenPoint
        //
        // ▿ (5.0, 500.0)
        // - x : 5.0
        // - y : 500.0
        //
        // The issues don't stop there. Even if we get a coordinate with satisfactory screenPoint,
        // taps might not work.  Taps don't work if Y coordinate <= 20.
        //
        // To make life easier we patch coordinates (sacrificing the error at the attemt of tapping on status bar
        // TODO: add an error for that case, it might be useful. Maybe it is possible to tap on a view at that
        // coordinates, so in order to tap on status bar we can place a transparent view and tap over it).
        
        var x = x
        var y = y
        
        let frame = ApplicationFrameProvider.frame
        // can trigger reloading AX hierarchy, polling for "idle" state of the app and maybe something else
        
        let minX: CGFloat = 0 // same effect for any negative number
        let minY: CGFloat = 20 // doesn't work with 19 or lower
        let maxX: CGFloat = frame.width - 1 // without `- 1` it is divided by 2
        let maxY: CGFloat = frame.height - 1 // without `- 1` it is divided by 2
        
        if x > maxX { x = maxX }
        if y > maxY { y = maxY }
        if x < minX { x = minX }
        if y < minY { y = minY }
        
        // Alternative: We can normalize x and y and do not use withOffset. However, it doesn't give us anything.
        return coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
            .withOffset(CGVector(dx: x, dy: y))
    }
}
