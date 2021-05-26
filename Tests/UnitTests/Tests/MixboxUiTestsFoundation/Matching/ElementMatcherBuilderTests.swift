import MixboxUiTestsFoundation
import MixboxTestsFoundation
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
    
    func test___frame() {
        let rect = CGRect(x: 1, y: 2, width: 3, height: 4)
        
        assertMatches(
            stub: { $0.frame = .available(rect) },
            check: { $0.frame == rect }
        )
        assertMismatches(
            stub: { $0.frame = .unavailable },
            check: { $0.frame == rect }
        )
    }
    
    func test___frameRelativeToScreen() {
        let rect = CGRect(x: 1, y: 2, width: 3, height: 4)
        
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { $0.frameRelativeToScreen == rect }
        )
    }
    
    func test_hasKeyboardFocus() {
        assertMatches(
            stub: { $0.hasKeyboardFocus = true },
            check: { $0.hasKeyboardFocus == true }
        )
        assertMatches(
            stub: { $0.hasKeyboardFocus = false },
            check: { $0.hasKeyboardFocus == false }
        )
        assertMismatches(
            stub: { $0.hasKeyboardFocus = true },
            check: { $0.hasKeyboardFocus == false }
        )
        assertMismatches(
            stub: { $0.hasKeyboardFocus = false },
            check: { $0.hasKeyboardFocus == true }
        )
    }
    
    func test_label() {
        assertMatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { $0.accessibilityLabel == "FOO" }
        )
        assertMismatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { $0.accessibilityLabel == "BAR" }
        )
        assertMatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { $0.accessibilityLabel != "BAR" }
        )
        assertMismatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { $0.accessibilityLabel != "FOO" }
        )
        assertMatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { "FOO" == $0.accessibilityLabel }
        )
        assertMismatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { "BAR" == $0.accessibilityLabel }
        )
        assertMatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { "BAR" != $0.accessibilityLabel }
        )
        assertMismatches(
            stub: { $0.accessibilityLabel = "FOO" },
            check: { "FOO" != $0.accessibilityLabel }
        )
    }
    
    func test_value() {
        assertMatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { $0.accessibilityValue == "FOO" }
        )
        assertMismatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { $0.accessibilityValue == "BAR" }
        )
        assertMatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { $0.accessibilityValue != "BAR" }
        )
        assertMismatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { $0.accessibilityValue != "FOO" }
        )
        assertMatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { "FOO" == $0.accessibilityValue }
        )
        assertMismatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { "BAR" == $0.accessibilityValue }
        )
        assertMatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { "BAR" != $0.accessibilityValue }
        )
        assertMismatches(
            stub: { $0.accessibilityValue = "FOO" },
            check: { "FOO" != $0.accessibilityValue }
        )
    }
    
    func test_placeholderValue() {
        assertMatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { $0.accessibilityPlaceholderValue == "FOO" }
        )
        assertMismatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { $0.accessibilityPlaceholderValue == "BAR" }
        )
        assertMatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { $0.accessibilityPlaceholderValue != "BAR" }
        )
        assertMismatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { $0.accessibilityPlaceholderValue != "FOO" }
        )
        assertMatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { "FOO" == $0.accessibilityPlaceholderValue }
        )
        assertMismatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { "BAR" == $0.accessibilityPlaceholderValue }
        )
        assertMatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { "BAR" != $0.accessibilityPlaceholderValue }
        )
        assertMismatches(
            stub: { $0.accessibilityPlaceholderValue = "FOO" },
            check: { "FOO" != $0.accessibilityPlaceholderValue }
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
    
    func test___operators_for_equatable() {
        let rect = CGRect(x: 1, y: 2, width: 3, height: 4)
        
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { $0.frameRelativeToScreen.origin.x == 1 }
        )
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { 1 == $0.frameRelativeToScreen.origin.x }
        )
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { $0.frameRelativeToScreen.origin.x != 2 }
        )
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { 2 != $0.frameRelativeToScreen.origin.x }
        )
    }
    
    // swiftlint:disable:next function_body_length
    func test___operators_for_comparable() {
        let rect = CGRect(x: 1, y: 2, width: 3, height: 4)
        
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { $0.frameRelativeToScreen.origin.x >= 1 }
        )
        assertMismatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { $0.frameRelativeToScreen.origin.x >= 2 }
        )
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { $0.frameRelativeToScreen.origin.x <= 1 }
        )
        assertMismatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { $0.frameRelativeToScreen.origin.x <= 0 }
        )
        
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { 1 <= $0.frameRelativeToScreen.origin.x }
        )
        assertMismatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { 2 <= $0.frameRelativeToScreen.origin.x }
        )
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { 1 >= $0.frameRelativeToScreen.origin.x }
        )
        assertMismatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { 0 >= $0.frameRelativeToScreen.origin.x }
        )
        
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { $0.frameRelativeToScreen.origin.x > 0 }
        )
        assertMismatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { $0.frameRelativeToScreen.origin.x > 1 }
        )
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { $0.frameRelativeToScreen.origin.x < 2 }
        )
        assertMismatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { $0.frameRelativeToScreen.origin.x < 1 }
        )
        
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { 0 < $0.frameRelativeToScreen.origin.x }
        )
        assertMismatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { 1 < $0.frameRelativeToScreen.origin.x }
        )
        assertMatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { 2 > $0.frameRelativeToScreen.origin.x }
        )
        assertMismatches(
            stub: { $0.frameRelativeToScreen = rect },
            check: { 1 > $0.frameRelativeToScreen.origin.x }
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
                $0.id == "1" && $0.accessibilityLabel == "2"
            }
        )
        assertMismatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
                $0.failForNotStubbedValues = false
            },
            check: {
                $0.id == "1" && $0.accessibilityLabel == "x"
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
                $0.id == "x" && $0.accessibilityLabel == "2"
            },
            percentageOfMatching: 0.5
        )
        assertMismatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
            },
            check: {
                $0.id == "x" && $0.accessibilityLabel == "x"
            }
        )
        assertMatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
                $0.accessibilityValue = "3"
            },
            check: {
                $0.id == "1" && $0.accessibilityLabel == "2" && $0.accessibilityValue == "3"
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
                $0.id == "1" && $0.accessibilityLabel == "x" && $0.accessibilityValue == "3"
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
                $0.id == "x" && $0.accessibilityLabel == "2" && $0.accessibilityValue == "x"
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
                $0.id == "1" || $0.accessibilityLabel == "2"
            }
        )
        assertMatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
            },
            check: {
                $0.id == "x" || $0.accessibilityLabel == "2"
            }
        )
        assertMatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
            },
            check: {
                $0.id == "1" || $0.accessibilityLabel == "x"
            }
        )
        assertMismatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
            },
            check: {
                $0.id == "x" || $0.accessibilityLabel == "x"
            }
        )
        assertMatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
                $0.accessibilityValue = "3"
            },
            check: {
                $0.id == "1" || $0.accessibilityLabel == "2" || $0.accessibilityValue == "3"
            }
        )
        assertMatches(
            stub: {
                $0.accessibilityIdentifier = "1"
                $0.accessibilityLabel = "2"
                $0.accessibilityValue = "3"
            },
            check: {
                $0.id == "x" || $0.accessibilityLabel == "2" || $0.accessibilityValue == "x"
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
                    $0.id == "1" || $0.accessibilityLabel == "2" && $0.accessibilityValue == "x"
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
                    $0.id == "x" && $0.accessibilityLabel == "2" || $0.accessibilityValue == "3"
                }
            )
        } else {
            XCTFail("Impossible!")
        }
    }
    
    func test___isDirectSubviewOf() {
        let superview = ElementSnapshotStub {
            $0.accessibilityIdentifier = "superview"
        }
        let directSuperview = ElementSnapshotStub {
            $0.accessibilityIdentifier = "directSuperview"
        }
        let subview = ElementSnapshotStub {
            $0.accessibilityIdentifier = "subview"
        }
        
        superview.add(child: directSuperview)
        directSuperview.add(child: subview)
        
        assertMatches(
            locator: { element in
                element.isDirectSubviewOf { element in
                    element.id == "directSuperview"
                }
            },
            snapshot: subview
        )
        
        assertMismatches(
            locator: { element in
                element.isDirectSubviewOf { element in
                    element.id == "superview"
                }
            },
            snapshot: subview
        )
    }
    
    private func assertMatches(
        stub: (ElementSnapshotStub) -> (),
        check: ElementMatcherBuilderClosure,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        let snapshot = ElementSnapshotStub(
            file: file,
            line: line,
            configure: stub
        )
        let matcher = check(ElementMatcherBuilderFactory.elementMatcherBuilder())
        
        assertMatches(
            matcher: matcher,
            value: snapshot,
            file: file,
            line: line
        )
    }
    
    private func assertMismatches(
        stub: (ElementSnapshotStub) -> (),
        check: ElementMatcherBuilderClosure,
        percentageOfMatching: Double = 0,
        file: StaticString = #filePath,
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
