import XCTest
import TestsIpc
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxUiKit

final class NonViewElementsTests: TestCase {
    private var mapView: NonViewElementsTestsMapViewPageObject {
        return pageObjects.nonViewElementsTestsMapView.default
    }
    
    private var customDrawingView: NonViewElementsTestsCustomDrawingViewPageObject {
        return pageObjects.nonViewElementsTestsCustomDrawingView.uikit // TODO: Support both uikit and xcui? 
    }
    
    // MKMapView actually contains UIView's, so in this sense the test doesn't belong in this TestCase,
    // however it reproduced an error that was introduced after supporting non-view elements (duplication of elements).
    // And the code is already written and the more tests the better.
    func test___map() {
        open(screen: mapView).waitUntilViewIsLoaded()
        
        mapView.pin.withoutTimeout.assertIsDisplayed()
    }
    
    func test___customDrawing() {
        open(screen: customDrawingView).waitUntilViewIsLoaded()
        
        func check(_ element: ViewElement) {
            element.withoutTimeout.tap()
            element.withoutTimeout.assertMatches {
                $0.customValues["isTapped"] == true
            }
        }

        // We are testing several elements to check whether tapping on fake elements work,
        // e.g, we didn't mess up with frames, etc.
        check(customDrawingView.element0)
        check(customDrawingView.element1)
        check(customDrawingView.element2)
    }
}
