@testable import Cocoapods
import XCTest

final class ThrowingScannerTests: XCTestCase {
    func test___scanWhile() {
        assertDoesntThrow {
            let scanner = ThrowingScannerImpl(string: "xyz")
            try scanner.scanWhile("x")
            
            XCTAssertEqual(
                scanner.remainingString(),
                "yz"
            )
        }
    }
    
    func test___scanWhile___fails_if_remaining_string_doesnt_start_with_given_string() {
        assertThrows {
            let scanner = ThrowingScannerImpl(string: "xyz")
            try scanner.scanWhile("y")
        }
    }
    
    func test___scanPass_0() {
        assertDoesntThrow {
            let scanner = ThrowingScannerImpl(string: "xyz")
            
            XCTAssertEqual(
                try scanner.scanPass("y"),
                "x"
            )
            XCTAssertEqual(
                scanner.remainingString(),
                "z"
            )
        }
    }
    
    func test___scanPass_1() {
        assertDoesntThrow {
            let scanner = ThrowingScannerImpl(string: "xyz")
            
            XCTAssertEqual(
                try scanner.scanPass("x"),
                ""
            )
            XCTAssertEqual(
                scanner.remainingString(),
                "yz"
            )
        }
    }
    
    func test___scanPass___fails_if_remaining_string_doesnt_contain_given_string() {
        assertThrows {
            let scanner = ThrowingScannerImpl(string: "xyz")
            try scanner.scanPass("?")
        }
    }
    
    func test___scanUntil() {
        assertDoesntThrow {
            let scanner = ThrowingScannerImpl(string: "xyz")
            
            XCTAssertEqual(
                try scanner.scanUntil("y"),
                "x"
            )
            XCTAssertEqual(
                scanner.remainingString(),
                "yz"
            )
        }
    }
    
    func test___scanToEnd() {
        assertDoesntThrow {
            let scanner = ThrowingScannerImpl(string: "xyz")
            
            try scanner.scanWhile("x")
            
            XCTAssertEqual(
                try scanner.scanToEnd(),
                "yz"
            )
        }
    }
}
