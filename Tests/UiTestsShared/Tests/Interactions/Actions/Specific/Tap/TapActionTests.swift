import MixboxUiTestsFoundation
import XCTest

// TODO: Check tapping on overlapping views:
//
//   +-----------------------------------+
//   |a                                  |
//   |              +-----+              |
//   |              |b    |              |
//   |              |     |              |
//   |              +-----+              |
//   |                                   |
//   +-----------------------------------+
//
// Steps to reproduce: a.tap()
// Expected result: `a` tapped
// Actual result: `b` tapped
//
// It is possible to detect visible area of `a`, or that center of `a` is not visible.
//
final class TapActionTests: BaseActionTestCase {
    func test_touches() {
        setViews(
            showInfo: true,
            actionSpecifications: [actionSpecification]
        )
        
        let uiEventHistory = recordTouches {
            actionSpecification.element(screen).tap()
            sleep(2) // TODO: Remove sleep, e.g.: add polling
        }
        
        guard let frame = (actionSpecification.element(screen).value(valueTitle: "frameOnScreen") { $0.frameOnScreen }) else {
            XCTFail("Can not get frameOnScreen")
            return
        }
        
        guard uiEventHistory.uiEventHistoryRecords.count == 2 else {
            XCTFail("Expected exactly 2 touch events")
            return
        }
        
        let firstEvent = uiEventHistory.uiEventHistoryRecords[0].event
        let secondEvent = uiEventHistory.uiEventHistoryRecords[1].event
        
        guard let firstTouch = firstEvent.allTouches.first, firstEvent.allTouches.count == 1 else {
            XCTFail("Expected exactly 1 touch in first event")
            return
        }
        
        guard let secondTouch = secondEvent.allTouches.first, secondEvent.allTouches.count == 1 else {
            XCTFail("Expected exactly 1 touch in second event")
            return
        }
        
        XCTAssertEqual(firstEvent.type, .touches)
        XCTAssertEqual(firstEvent.subtype, .none)
        
        XCTAssertEqual(firstTouch.phase, .began)
        
        XCTAssertEqual(secondEvent.type, .touches)
        XCTAssertEqual(secondEvent.subtype, .none)
        
        XCTAssertEqual(secondTouch.phase, .ended)
        
        XCTAssertEqual(secondTouch.phase, .ended)
        
        let center = frame.mb_center
        
        XCTAssertEqual(center, firstTouch.location)
        XCTAssertEqual(center, firstTouch.preciseLocation)
        XCTAssertEqual(center, secondTouch.location)
        XCTAssertEqual(center, secondTouch.preciseLocation)
    }
    
    func test_action_canBeRunSubsequentlyWithSameResult() {
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: actionSpecification,
            resetViewsForCurrentActionSpecification: true
        )
    }
    
    func test_action_waitsElementToAppear() {
        checkActionWaitsElementToAppear(
            actionSpecification: actionSpecification
        )
    }
    
    func test_action_waitsUntilElementIsNotDuplicated() {
        checkActionWaitsUntilElementIsNotDuplicated(
            actionSpecification: actionSpecification
        )
    }
    
    private var actionSpecification: ActionSpecification<ButtonElement> {
        return tapActionSpecification
    }
}
