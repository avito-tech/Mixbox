import MixboxIpcCommon
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
        actual: CGPoint,
        expected: CGPoint,
        file: StaticString = #file,
        line: UInt = #line)
    {
        func message() -> String {
            return "Actual: \(actual). Expected: \(expected)"
        }
        
        XCTAssertEqual(actual.x, expected.x, accuracy: relativeCoordinatesAccuracy, message(), file: file, line: line)
        XCTAssertEqual(actual.y, expected.y, accuracy: relativeCoordinatesAccuracy, message(), file: file, line: line)
    }
    
    func assertEqual(
        actual: CGVector,
        expected: CGVector,
        file: StaticString = #file,
        line: UInt = #line)
    {
        func message() -> String {
            return "Actual: \(actual). Expected: \(expected)"
        }
        
        XCTAssertEqual(actual.dx, expected.dx, accuracy: relativeCoordinatesAccuracy, message(), file: file, line: line)
        XCTAssertEqual(actual.dy, expected.dy, accuracy: relativeCoordinatesAccuracy, message(), file: file, line: line)
    }
    
    func assertAbsoluteCoordinatesAreEqual(
        actual: CGPoint,
        expected: CGPoint,
        file: StaticString = #file,
        line: UInt = #line)
    {
        func message() -> String {
            return "Actual: \(actual). Expected: \(expected)"
        }
        
        XCTAssertEqual(actual.x, expected.x, accuracy: absoluteCoordinatesAccuracy, message(), file: file, line: line)
        XCTAssertEqual(actual.y, expected.y, accuracy: absoluteCoordinatesAccuracy, message(), file: file, line: line)
    }
}
