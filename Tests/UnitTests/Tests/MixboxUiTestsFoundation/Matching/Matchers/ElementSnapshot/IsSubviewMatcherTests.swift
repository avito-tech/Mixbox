import Foundation
import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest

class IsSubviewMatcherTests: BaseMatcherTests {
    func test___match___matches___if_superview_matches() {
        let superview = ElementSnapshotStub {
            $0.accessibilityIdentifier = "superview"
        }
        let viewThatIsBeingMatched = ElementSnapshotStub {
            $0.accessibilityIdentifier = "subview"
        }
        
        superview.add(child: viewThatIsBeingMatched)
        
        assertMatches(
            matcher: IsSubviewMatcher(matcherBuilder.id == "superview"),
            value: viewThatIsBeingMatched
        )
    }

    func test___match___mismatches___view_that_is_being_matched() {
        let superview = ElementSnapshotStub {
            $0.accessibilityIdentifier = "superview"
            $0.failForNotStubbedValues = false
        }
        let viewThatIsBeingMatched = ElementSnapshotStub {
            $0.accessibilityIdentifier = "viewThatIsBeingMatched"
        }
        
        superview.add(child: viewThatIsBeingMatched)
        
        assertMismatches(
            matcher: IsSubviewMatcher(matcherBuilder.id == "viewThatIsBeingMatched"),
            value: viewThatIsBeingMatched
        )
    }
    
    func test___match___produces_correct_mismatch_description_0() {
        let superview0 = ElementSnapshotStub {
            $0.accessibilityIdentifier = "superview0"
            $0.isEnabled = false
            $0.failForNotStubbedValues = false
        }
        let superview1 = ElementSnapshotStub {
            $0.accessibilityIdentifier = "superview1"
            $0.isEnabled = true
            $0.failForNotStubbedValues = false
        }
        let superview2 = ElementSnapshotStub {
            $0.accessibilityIdentifier = "superview2"
            $0.isEnabled = false
            $0.failForNotStubbedValues = false
        }
        let viewThatIsBeingMatched = ElementSnapshotStub {
            $0.accessibilityIdentifier = "viewThatIsBeingMatched"
            $0.failForNotStubbedValues = false
        }
        
        superview0.add(child: superview1)
        superview1.add(child: superview2)
        superview2.add(child: viewThatIsBeingMatched)
        
        assertMismatches(
            matcher: IsSubviewMatcher(matcherBuilder.id == "non_existent_id" && matcherBuilder.isEnabled == true),
            value: viewThatIsBeingMatched,
            percentageOfMatching: 0.5,
            description:
            """
            не найден superview, который матчится матчером "All of [
                Имеет проперти id: equals to non_existent_id
                Имеет проперти isEnabled: equals to true
            ]", лучший кандидат зафейлился: All of [
                (x) value is not equal to 'non_existent_id', actual value: 'superview1'
                (v) Имеет проперти isEnabled: equals to true
            ]
            """
        )
    }
    
    func test___match___produces_correct_mismatch_description_1() {
        let superview = ElementSnapshotStub {
            $0.accessibilityIdentifier = "superview0"
            $0.failForNotStubbedValues = false
        }
        let viewThatIsBeingMatched = ElementSnapshotStub {
            $0.accessibilityIdentifier = "viewThatIsBeingMatched"
            $0.failForNotStubbedValues = false
        }
        
        superview.add(child: viewThatIsBeingMatched)
        
        assertMismatches(
            matcher: IsSubviewMatcher(matcherBuilder.id == "non_existent_id"),
            value: viewThatIsBeingMatched,
            percentageOfMatching: 0,
            description:
            """
            не найден superview, который матчится матчером "Имеет проперти id: equals to non_existent_id", лучший кандидат зафейлился: value is not equal to 'non_existent_id', actual value: 'superview0'
            """
        )
    }
    
    func test___description___is_correct() {
        let superview = ElementSnapshotStub {
            $0.accessibilityIdentifier = "superview"
        }
        let viewThatIsBeingMatched = ElementSnapshotStub {
            $0.accessibilityIdentifier = "subview"
        }
        
        superview.add(child: viewThatIsBeingMatched)
        
        assertDescriptionIsCorrect(
            matcher: IsSubviewMatcher(matcherBuilder.id == "superview"),
            value: viewThatIsBeingMatched,
            description:
            """
            Является сабвью {
                Имеет проперти id: equals to superview
            }
            """
        )
    }
}
