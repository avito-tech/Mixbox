import MixboxUiTestsFoundation
import XCTest

// TODO: Split to classes
// swiftlint:disable file_length
// swiftlint:disable type_body_length
final class MatcherBuilderTests: BaseMatcherTests {
    func test_id() {
        assertMatches(
            stub: { $0.accessibilityIdentifier = "FOO" },
            check: { $0.id == "FOO" }
        )
        assertMismatches(
            stub: { $0.accessibilityIdentifier = "FOO" },
            check: { $0.id == "BAR" }
        )
        assertMatches(
            stub: { $0.accessibilityIdentifier = "FOO" },
            check: { $0.id != "BAR" }
        )
        assertMismatches(
            stub: { $0.accessibilityIdentifier = "FOO" },
            check: { $0.id != "FOO" }
        )
        assertMatches(
            stub: { $0.accessibilityIdentifier = "FOO" },
            check: { "FOO" == $0.id }
        )
        assertMismatches(
            stub: { $0.accessibilityIdentifier = "FOO" },
            check: { "BAR" == $0.id }
        )
        assertMatches(
            stub: { $0.accessibilityIdentifier = "FOO" },
            check: { "BAR" != $0.id }
        )
        assertMismatches(
            stub: { $0.accessibilityIdentifier = "FOO" },
            check: { "FOO" != $0.id }
        )
    }
    
    func test_label() {
        assertMatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { $0.label == "FOO" }
        )
        assertMismatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { $0.label == "BAR" }
        )
        assertMatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { $0.label != "BAR" }
        )
        assertMismatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { $0.label != "FOO" }
        )
        assertMatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { "FOO" == $0.label }
        )
        assertMismatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { "BAR" == $0.label }
        )
        assertMatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { "BAR" != $0.label }
        )
        assertMismatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { "FOO" != $0.label }
        )
    }
    
    func test_value() {
        assertMatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { $0.value == "FOO" }
        )
        assertMismatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { $0.value == "BAR" }
        )
        assertMatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { $0.value != "BAR" }
        )
        assertMismatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { $0.value != "FOO" }
        )
        assertMatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { "FOO" == $0.value }
        )
        assertMismatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { "BAR" == $0.value }
        )
        assertMatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { "BAR" != $0.value }
        )
        assertMismatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { "FOO" != $0.value }
        )
    }
    
    func test_placeholderValue() {
        assertMatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { $0.placeholderValue == "FOO" }
        )
        assertMismatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { $0.placeholderValue == "BAR" }
        )
        assertMatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { $0.placeholderValue != "BAR" }
        )
        assertMismatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { $0.placeholderValue != "FOO" }
        )
        assertMatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { "FOO" == $0.placeholderValue }
        )
        assertMismatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { "BAR" == $0.placeholderValue }
        )
        assertMatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { "BAR" != $0.placeholderValue }
        )
        assertMismatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { "FOO" != $0.placeholderValue }
        )
    }
    
    func test_text() {
        assertMatches(
            stub: { $0.text = .available("FOO") },
            check: { $0.text == "FOO" }
        )
        assertMismatches(
            stub: { $0.text = .available("FOO") },
            check: { $0.text == "BAR" }
        )
        assertMatches(
            stub: { $0.text = .available("FOO") },
            check: { $0.text != "BAR" }
        )
        assertMismatches(
            stub: { $0.text = .available("FOO") },
            check: { $0.text != "FOO" }
        )
        assertMatches(
            stub: { $0.text = .available("FOO") },
            check: { "FOO" == $0.text }
        )
        assertMismatches(
            stub: { $0.text = .available("FOO") },
            check: { "BAR" == $0.text }
        )
        assertMatches(
            stub: { $0.text = .available("FOO") },
            check: { "BAR" != $0.text }
        )
        assertMismatches(
            stub: { $0.text = .available("FOO") },
            check: { "FOO" != $0.text }
        )
    }
    
    func test_isEnabled() {
        assertMatches(
            stub: { $0.isEnabled = true },
            check: { $0.isEnabled == true }
        )
        assertMismatches(
            stub: { $0.isEnabled = true },
            check: { $0.isEnabled == false }
        )
        assertMatches(
            stub: { $0.isEnabled = false },
            check: { $0.isEnabled == false }
        )
        assertMismatches(
            stub: { $0.isEnabled = false },
            check: { $0.isEnabled == true }
        )
        
        // TODO:
        //
        // assertMatches(
        //     stub: { $0.isEnabled = true },
        //     check: { $0.isEnabled }
        // )
    }
    
    func test_type() {
        assertMatches(
            stub: { $0.elementType = .other },
            check: { $0.type == .other }
        )
        assertMatches(
            stub: { $0.elementType = .button },
            check: { $0.type != .switch }
        )
        assertMismatches(
            stub: { $0.elementType = .button },
            check: { $0.type != .button }
        )
    }
    
    // swiftlint:disable:next function_body_length
    func test_and() {
        assertMatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
            },
            check: {
                $0.id == "1" && $0.label == "2"
            }
        )
        assertMismatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
                $0.failForNotStubbedValues = false
            },
            check: {
                $0.id == "1" && $0.label == "x"
            },
            percentageOfMatching: 0.5
        )
        assertMismatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
                $0.failForNotStubbedValues = false
            },
            check: {
                $0.id == "x" && $0.label == "2"
            },
            percentageOfMatching: 0.5
        )
        assertMismatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
            },
            check: {
                $0.id == "x" && $0.label == "x"
            }
        )
        assertMatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
                $0.accessibilityValue = "3"
            },
            check: {
                $0.id == "1" && $0.label == "2" && $0.value == "3"
            }
        )
        assertMismatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
                $0.accessibilityValue = "3"
                $0.failForNotStubbedValues = false
            },
            check: {
                $0.id == "1" && $0.label == "x" && $0.value == "3"
            },
            // This is due to && makes two arrays in AndMatcher instead of a single array with 3 elements.
            // (1 - 0.5 * 0.5) == 0.75
            percentageOfMatching: 0.75
        )
        assertMismatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
                $0.accessibilityValue = "3"
                $0.failForNotStubbedValues = false
            },
            check: {
                $0.id == "x" && $0.label == "2" && $0.value == "x"
            },
            percentageOfMatching: 0.25
        )
    }
    
    func test_or() {
        assertMatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
            },
            check: {
                $0.id == "1" || $0.label == "2"
            }
        )
        assertMatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
            },
            check: {
                $0.id == "x" || $0.label == "2"
            }
        )
        assertMatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
            },
            check: {
                $0.id == "1" || $0.label == "x"
            }
        )
        assertMismatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
            },
            check: {
                $0.id == "x" || $0.label == "x"
            }
        )
        assertMatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
                $0.accessibilityValue = "3"
            },
            check: {
                $0.id == "1" || $0.label == "2" || $0.value == "3"
            }
        )
        assertMatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
                $0.accessibilityValue = "3"
            },
            check: {
                $0.id == "x" || $0.label == "2" || $0.value == "x"
            }
        )
    }
    
    func test_and_or() {
        if true || true && false {
            assertMatches(
                stub: {
                    $0.accessibilityIdentifier = "1"
                    $0.accessibilityLabel = "2"
                    $0.accessibilityValue = "3"
                },
                check: {
                    $0.id == "1" || $0.label == "2" && $0.value == "x"
                }
            )
        } else {
            XCTFail("Impossible!")
        }
        
        if false && true || true {
            assertMatches(
                stub: {
                    $0.accessibilityIdentifier = "1"
                    $0.accessibilityLabel = "2"
                    $0.accessibilityValue = "3"
                },
                check: {
                    $0.id == "x" && $0.label == "2" || $0.value == "3"
                }
            )
        } else {
            XCTFail("Impossible!")
        }
    }
    
    private func assertMatches(
        stub: (ElementSnapshotStub) -> (),
        check: ElementMatcherBuilderClosure,
        file: StaticString = #file,
        line: UInt = #line)
    {
        let snapshot = ElementSnapshotStub(
            file: file,
            line: line,
            configure: stub
        )
        let matcher = check(ElementMatcherBuilderFactory.elementMatcherBuilder())
        
        assertMatches(matcher: matcher, value: snapshot)
    }
    
    private func assertMismatches(
        stub: (ElementSnapshotStub) -> (),
        check: ElementMatcherBuilderClosure,
        percentageOfMatching: Double = 0,
        file: StaticString = #file,
        line: UInt = #line)
    {
        let snapshot = ElementSnapshotStub(
            file: file,
            line: line,
            configure: stub
        )
        let matcher = check(ElementMatcherBuilderFactory.elementMatcherBuilder())
        
        assertMismatches(
            matcher: matcher,
            value: snapshot,
            percentageOfMatching: percentageOfMatching,
            description: nil,
            file: file,
            line: line
        )
    }
}
