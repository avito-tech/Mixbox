import XCTest
import TestsIpc
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxUiKit

// TODO (non-view elements): Fix for gray box
final class NonViewElementsTests: TestCase {
    private var webView: NonViewElementsTestsWebViewPageObject {
        return pageObjects.nonViewElementsTestsWebView.default
    }
    
    private var mapView: NonViewElementsTestsMapViewPageObject {
        return pageObjects.nonViewElementsTestsMapView.default
    }
    
    private var customDrawingView: NonViewElementsTestsCustomDrawingViewPageObject {
        return pageObjects.nonViewElementsTestsCustomDrawingView.default
    }
    
    func test___web() {
        open(screen: webView).waitUntilViewIsLoaded()
        
        // Webview is asynchronous, so we have to wait.
        webView.header.assertIsDisplayed()
        webView.paragraph.withoutTimeout.assertIsDisplayed()
    }
    
    func test___map() {
        open(screen: mapView).waitUntilViewIsLoaded()
        
        mapView.pin.withoutTimeout.assertIsDisplayed()
    }
    
    func test___customDrawing() {
        open(screen: customDrawingView).waitUntilViewIsLoaded()
        
        func check(_ element: ViewElement) {
            element.withoutTimeout.tap()
            element.withoutTimeout.assertMatches {
                $0.customValues["tapped"] == true
            }
        }

        // We are testing several elements to check whether tapping on fake elements work,
        // e.g, we didn't mess up with frames, etc.
        check(customDrawingView.element0)
        check(customDrawingView.element1)
        check(customDrawingView.element2)
    }
}
