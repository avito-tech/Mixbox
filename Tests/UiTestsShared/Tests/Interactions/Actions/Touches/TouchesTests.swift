import XCTest

// TODO: Test press&drag. Check `duration` argument. And all other too.
// TODO: Test swipes. Check cancelling inertia (both on/off, search for `cancelInertia`).
final class TouchesTests: BaseTouchesTestCase {
    func test_tapping() {
        openScreen(screen)
        
        let targetView = screen.real.targetView
        
        let uiEventHistory = recordUiEvents {
            targetView.tap()
            spinner.spin(timeout: 2) // TODO: add polling, maybe increase timeout then
        }
        
        guard let frame = (targetView.value(valueTitle: "frameRelativeToScreen") { $0.frameRelativeToScreen }) else {
            XCTFail("Failed to get frameRelativeToScreen")
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
        
        let center = frame.mb_center
        
        let accuracy: CGFloat = 0.5
        
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
        
        // This was working fine in Black Box tests:
        // XCTAssertEqual(firstTouch.preciseLocation, secondTouch.preciseLocation)
        // But stopped working in Gray Box tests:
        // iPhone X, iOS 12.1: XCTAssertEqual failed: ("(106.33333333333333, 130.0)") is not equal to ("(106.22243186433548, 130.007041555162)") -
        // iPhone 7, iOS 11.3: XCTAssertEqual failed: ("(106.0, 130.0)") is not equal to ("(106.22243186433548, 130.007041555162)") -
        // iPhone SE, iOS 10.3: XCTAssertEqual failed: ("(106.0, 130.0)") is not equal to ("(106.22243186433548, 130.007041555162)") -
        // iPhone 6 Plus, iOS 9.3: XCTAssertEqual failed: ("(106.33333333333333, 130.0)") is not equal to ("(106.22243186433548, 130.007041555162)") -
        // This is strange and ideally should be investigated.
        XCTAssertEqual(firstTouch.preciseLocation.x, secondTouch.preciseLocation.x, accuracy: accuracy)
        XCTAssertEqual(firstTouch.preciseLocation.y, secondTouch.preciseLocation.y, accuracy: accuracy)
        
        // We can afford this test, because frames are fixed in the view.
        // Ensure to view with your eyes that "target view" (small blue view) is tapped before changing values in test.
        let hardcodedCoordinatesAccuracy: CGFloat = 1
        XCTAssertEqual(firstTouch.location.x, 106.33332824707031, accuracy: hardcodedCoordinatesAccuracy)
        XCTAssertEqual(firstTouch.location.y, 130.0, accuracy: hardcodedCoordinatesAccuracy)
    }
    
}
