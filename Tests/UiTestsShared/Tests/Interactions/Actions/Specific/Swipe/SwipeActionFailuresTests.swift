import XCTest
import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxIpcCommon

final class SwipeActionFailuresTests: BaseActionTestCase {
    func test___swipeUp___fails_with_correct_description() {
        assertFails(
            description:
            """
            "swipe in input non-existing-element from center of element up" failed, because: element was not found in hierarchy
            """
        ) {
            screen.input("non-existing-element").withoutTimeout.swipeUp()
        }
    }
    
    func test___swipeDown___fails_with_correct_description() {
        assertFails(
            description:
            """
            "swipe in input non-existing-element from center of element down" failed, because: element was not found in hierarchy
            """
        ) {
            screen.input("non-existing-element").withoutTimeout.swipeDown()
        }
    }
    
    func test___swipeLeft___fails_with_correct_description() {
        assertFails(
            description:
            """
            "swipe in input non-existing-element from center of element left" failed, because: element was not found in hierarchy
            """
        ) {
            screen.input("non-existing-element").withoutTimeout.swipeLeft()
        }
    }
    
    func test___swipeRight___fails_with_correct_description() {
        assertFails(
            description:
            """
            "swipe in input non-existing-element from center of element right" failed, because: element was not found in hierarchy
            """
        ) {
            screen.input("non-existing-element").withoutTimeout.swipeRight()
        }
    }
    
    func test___swipe_with_direction___fails_with_correct_description() {
        assertFails(
            description:
            """
            "swipe in input non-existing-element from center of element up by 10.0 points" failed, because: element was not found in hierarchy
            """
        ) {
            screen.input("non-existing-element").withoutTimeout.swipe(direction: .up, length: 10, speed: .duration(0.1))
        }
    }
    
    func test___swipe_with_coordinates___fails_with_correct_description() {
        assertFails(
            description:
            """
            "swipe in input non-existing-element from point with relative normalized coordinates (0.3; 0.4) with absolute offset (10.0; 20.0) to point with relative normalized coordinates (0.5; 0.6) with absolute offset (30.0; 40.0)" failed, because: element was not found in hierarchy
            """
        ) {
            screen.input("non-existing-element").withoutTimeout.swipe(
                startPoint: InteractionCoordinates(
                    normalizedCoordinate: CGPoint(x: 0.3, y: 0.4),
                    absoluteOffset: CGVector(dx: 10, dy: 20)
                ),
                endPoint: SwipeActionEndPoint.interactionCoordinates(
                    InteractionCoordinates(
                        normalizedCoordinate: CGPoint(x: 0.5, y: 0.6),
                        absoluteOffset: CGVector(dx: 30, dy: 40)
                    )
                ),
                speed: .velocity(1000)
            )
        }
    }
}
