import XCTest
import MixboxUiTestsFoundation
import MixboxUiKit

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
                    startPoint: .interactionCoordinates(
                        InteractionCoordinates(
                            normalizedCoordinate: CGPoint(x: 0.5, y: 0.5),
                            absoluteOffset: startPointOffset
                        )
                    ),
                    endPoint: .interactionCoordinates(
                        InteractionCoordinates(
                            normalizedCoordinate: CGPoint(x: 0.5, y: 0.5),
                            absoluteOffset: CGVector(dx: 50, dy: 50)
                        )
                    )
                )
            },
            startPointOffsetFromCenter: startPointOffset,
            startPointAbsolute: targetViewCenter + startPointOffset,
            endPointOffsetFromStartPoint: CGVector(dx: 100, dy: 100)
        )
    }
    
    override func precondition() {
        super.precondition()
        
        open()
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
            
            assertEqual(firstTouch.location, try targetViewFrameCenterToWindow() + startPointOffsetFromCenter)
            assertEqual(firstTouch.preciseLocation, try targetViewFrameCenter() + startPointOffsetFromCenter)
            
            assertEqual(lastTouch.location - firstTouch.location, endPointOffsetFromStartPoint)
            assertEqual(lastTouch.preciseLocation - firstTouch.preciseLocation, endPointOffsetFromStartPoint)
            
            assertAbsoluteCoordinatesAreEqual(firstTouch.location, startPointAbsolute)
            assertAbsoluteCoordinatesAreEqual(lastTouch.location, startPointAbsolute + endPointOffsetFromStartPoint)
        } catch {
            XCTFail("\(error)")
        }
    }
}
