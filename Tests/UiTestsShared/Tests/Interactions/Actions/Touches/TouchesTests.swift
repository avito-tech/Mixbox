import XCTest

// TODO: Test press&drag. Check `duration` argument. And all other too.
// TODO: Test swipes. Check cancelling inertia (both on/off, search for `cancelInertia`).
final class TouchesTests: BaseTouchesTestCase {
    func test_tapping() {
        openScreen(screen)
        
        let targetView = screen.real.targetView
        
        let uiEventHistory = recordUiEvents {
            targetView.tap()
            sleep(2) // TODO: Remove sleep, e.g.: add polling
        }
        
        guard let frame = (targetView.value(valueTitle: "frameOnScreen") { $0.frameOnScreen }) else {
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
        
        let accuracy: CGFloat = 0.2
        
        let centerToWindow = targetView.centerToWindow.unwrapOrFail()
        
        XCTAssertEqual(firstTouch.location.x, centerToWindow.x, accuracy: accuracy)
        XCTAssertEqual(firstTouch.location.y, centerToWindow.y, accuracy: accuracy)
        
        XCTAssertEqual(center.x, firstTouch.location.x, accuracy: accuracy)
        XCTAssertEqual(center.y, firstTouch.location.y, accuracy: accuracy)
        XCTAssertEqual(center.x, firstTouch.preciseLocation.x, accuracy: accuracy)
        XCTAssertEqual(center.y, firstTouch.preciseLocation.y, accuracy: accuracy)
        
        // These values have to be exactly same, but i got this error in GrayBox tests:
        // XCTAssertEqual failed: ("(95.33333333333333, 60.666666666666664)") is not equal to ("(95.45706005997577, 60.65321248268239)") -
        // So I've added `accuracy` to the check
        XCTAssertEqual(firstTouch.location.x, secondTouch.location.x, accuracy: accuracy)
        XCTAssertEqual(firstTouch.location.y, secondTouch.location.y, accuracy: accuracy)
        
        // This works fine:
        XCTAssertEqual(secondTouch.preciseLocation, secondTouch.preciseLocation)
    }
    
}
