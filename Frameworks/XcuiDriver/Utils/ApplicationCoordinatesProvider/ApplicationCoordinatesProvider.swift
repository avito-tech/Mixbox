import XCTest
import MixboxUiTestsFoundation

public protocol ApplicationCoordinatesProvider: class {
    func tappablePoint(point: CGPoint) -> CGPoint
    func coordinate(tappablePoint: CGPoint) -> XCUICoordinate
}

public extension ApplicationCoordinatesProvider {
    func tappableCoordinate(point: CGPoint) -> XCUICoordinate {
        return coordinate(tappablePoint: tappablePoint(point: point))
    }
    
    func tappableCoordinate(x: CGFloat, y: CGFloat) -> XCUICoordinate {
        return tappableCoordinate(point: CGPoint(x: x, y: y))
    }
}
