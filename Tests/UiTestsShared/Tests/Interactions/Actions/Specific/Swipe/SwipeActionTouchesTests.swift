import XCTest
import MixboxUiTestsFoundation
import MixboxUiKit
import MixboxIpcCommon

final class SwipeActionTouchesTests: BaseTouchesTestCase {
    let defaultSwipeOffset: CGFloat = 100
    
    func test___swipeUp___produces_expected_events() {
        parametrizedTest___swipe___produces_expected_events(
            swipeClosure: { $0.swipeUp() },
            startPointAbsolute: targetViewCenter,
            endPointOffsetFromStartPoint: CGVector(dx: 0, dy: -defaultSwipeOffset)
        )
    }
    
    func test___swipeDown___produces_expected_events() {
        parametrizedTest___swipe___produces_expected_events(
            swipeClosure: { $0.swipeDown() },
            startPointAbsolute: targetViewCenter,
            endPointOffsetFromStartPoint: CGVector(dx: 0, dy: defaultSwipeOffset)
        )
    }
    
    func test___swipeLeft___produces_expected_events() {
        parametrizedTest___swipe___produces_expected_events(
            swipeClosure: { $0.swipeLeft() },
            startPointAbsolute: targetViewCenter,
            endPointOffsetFromStartPoint: CGVector(dx: -defaultSwipeOffset, dy: 0)
        )
    }
    
    func test___swipeRight___produces_expected_events() {
        parametrizedTest___swipe___produces_expected_events(
            swipeClosure: { $0.swipeRight() },
            startPointAbsolute: targetViewCenter,
            endPointOffsetFromStartPoint: CGVector(dx: defaultSwipeOffset, dy: 0)
        )
    }
    
    func test___swipe___uses_default_length___if_length_is_not_passed() {
        parametrizedTest___swipe___produces_expected_events(
            swipeClosure: { $0.swipeDown(length: nil) },
            startPointAbsolute: targetViewCenter,
            endPointOffsetFromStartPoint: CGVector(dx: 0, dy: defaultSwipeOffset)
        )
    }
    
    func test___swipe___respects_swipe_length() {
        parametrizedTest___swipe___produces_expected_events(
            swipeClosure: { $0.swipeDown(length: 200) },
            startPointAbsolute: targetViewCenter,
            endPointOffsetFromStartPoint: CGVector(dx: 0, dy: 200)
        )
    }
    
    func test___swipe___respects_custom_coordinates() {
        let startPointOffset = CGVector(dx: -50, dy: -50)
        parametrizedTest___swipe___produces_expected_events(
            swipeClosure: {
                $0.swipe(
                    startPoint: InteractionCoordinates(
                        normalizedCoordinate: CGPoint(x: 0.5, y: 0.5),
                        absoluteOffset: startPointOffset,
                        mode: nil
                    ),
                    endPoint: .interactionCoordinates(
                        InteractionCoordinates(
                            normalizedCoordinate: CGPoint(x: 0.5, y: 0.5),
                            absoluteOffset: CGVector(dx: 50, dy: 50),
                            mode: nil
                        )
                    )
                )
            },
            startPointOffsetFromCenter: startPointOffset,
            startPointAbsolute: targetViewCenter + startPointOffset,
            endPointOffsetFromStartPoint: CGVector(dx: 100, dy: 100)
        )
    }
    
    private func parametrizedTest___swipe___produces_expected_events(
        swipeClosure: (ElementWithUi) -> (),
        startPointOffsetFromCenter: CGVector = .zero,
        startPointAbsolute: CGPoint,
        endPointOffsetFromStartPoint: CGVector)
    {
        do {
            recordUiEvents {
                swipeClosure(screen.targetView)
            }
            
            try requireNumberOfEvents(greaterThanOrEqualTo: 2)
            
            let firstEvent = try self.firstEvent()
            let lastEvent = try self.lastEvent()
            
            let firstTouch = try singleTouch(firstEvent)
            let lastTouch = try singleTouch(lastEvent)
            
            assertPhasesAreCorrect(
                beginEvent: firstEvent,
                endEvent: lastEvent
            )
            
            assertEqual(
                actual: firstTouch.location,
                expected: try targetViewFrameCenterToWindow() + startPointOffsetFromCenter
            )
            assertEqual(
                actual: firstTouch.preciseLocation,
                expected: try targetViewFrameCenter() + startPointOffsetFromCenter
            )
            
            assertEqual(
                actual: lastTouch.location - firstTouch.location,
                expected: endPointOffsetFromStartPoint
            )
            assertEqual(
                actual: lastTouch.preciseLocation - firstTouch.preciseLocation,
                expected: endPointOffsetFromStartPoint
            )
            
            assertAbsoluteCoordinatesAreEqual(
                actual: firstTouch.location,
                expected: startPointAbsolute
            )
            assertAbsoluteCoordinatesAreEqual(
                actual: lastTouch.location,
                expected: startPointAbsolute + endPointOffsetFromStartPoint
            )
        } catch {
            XCTFail("\(error)")
        }
    }
}
