import TestsIpc
import MixboxFoundation
import XCTest

extension BaseTouchesTestCase {
    func assertPhasesAreCorrect(
        beginEvent: UiEvent,
        endEvent: UiEvent,
        file: StaticString = #file,
        line: UInt = #line)
    {
        XCTAssertEqual(beginEvent.type, .touches, file: file, line: line)
        XCTAssertEqual(beginEvent.subtype, .none, file: file, line: line)
        
        XCTAssertEqual(try singleTouch(beginEvent).phase, .began, file: file, line: line)
        
        XCTAssertEqual(endEvent.type, .touches, file: file, line: line)
        XCTAssertEqual(endEvent.subtype, .none, file: file, line: line)
        
        XCTAssertEqual(try singleTouch(endEvent).phase, .ended, file: file, line: line)
    }
    
    // For relative coordinates
    func assertEqual(
        _ lhs: CGPoint,
        _ rhs: CGPoint,
        file: StaticString = #file,
        line: UInt = #line)
    {
        XCTAssertEqual(lhs.x, rhs.x, accuracy: relativeCoordinatesAccuracy, file: file, line: line)
        XCTAssertEqual(lhs.y, rhs.y, accuracy: relativeCoordinatesAccuracy, file: file, line: line)
    }
    
    func assertEqual(
        _ lhs: CGVector,
        _ rhs: CGVector,
        file: StaticString = #file,
        line: UInt = #line)
    {
        XCTAssertEqual(lhs.dx, rhs.dx, accuracy: relativeCoordinatesAccuracy, file: file, line: line)
        XCTAssertEqual(lhs.dy, rhs.dy, accuracy: relativeCoordinatesAccuracy, file: file, line: line)
    }
    
    func assertAbsoluteCoordinatesAreEqual(
        _ lhs: CGPoint,
        _ rhs: CGPoint,
        file: StaticString = #file,
        line: UInt = #line)
    {
        XCTAssertEqual(lhs.x, rhs.x, accuracy: absoluteCoordinatesAccuracy, file: file, line: line)
        XCTAssertEqual(lhs.y, rhs.y, accuracy: absoluteCoordinatesAccuracy, file: file, line: line)
    }
}
