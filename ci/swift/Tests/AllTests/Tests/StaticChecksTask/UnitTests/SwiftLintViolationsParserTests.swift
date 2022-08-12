import StaticChecksTask
import XCTest

public final class SwiftLintViolationsParserTests: XCTestCase {
    func test() {
        do {
            let stdout =
            """
            /Mixbox/ci/swift/Sources/Xcodebuild/Xcodebuild/XcodebuildImpl.swift:101:48: warning: Trailing Comma Violation: Collection literals should not have trailing commas. (trailing_comma)
            /Mixbox/ci/swift/Sources/Cocoapods/Cocoapods/BashCocoapods.swift:54:1: error: Vertical Whitespace Violation: Limit vertical whitespace to a single empty line. Currently 2. (vertical_whitespace)

            """
            
            let swiftLintViolationsParser: SwiftLintViolationsParser = SwiftLintViolationsParserImpl()
            
            let actualViolations = try swiftLintViolationsParser.parseViolations(stdout: stdout)
            
            let expectedViolations: [SwiftLintViolation] = [
                SwiftLintViolation(
                    file: "/Mixbox/ci/swift/Sources/Xcodebuild/Xcodebuild/XcodebuildImpl.swift",
                    line: 101,
                    column: 48,
                    type: .warning,
                    description: "Trailing Comma Violation: Collection literals should not have trailing commas.",
                    rule: "trailing_comma"
                ),
                SwiftLintViolation(
                    file: "/Mixbox/ci/swift/Sources/Cocoapods/Cocoapods/BashCocoapods.swift",
                    line: 54,
                    column: 1,
                    type: .error,
                    description: "Vertical Whitespace Violation: Limit vertical whitespace to a single empty line. Currently 2.",
                    rule: "vertical_whitespace"
                )
            ]
            
            XCTAssertEqual(actualViolations, expectedViolations)
        } catch {
            XCTFail("\(error)")
        }
    }
}
