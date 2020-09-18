import XCTest
import TestsIpc
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxUiKit

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
    
    func disabled_test___web() {
        open(screen: pageObjects.nonViewElementsTestsWebView)
            .waitUntilViewIsLoaded()
        
        webView.header.assertIsDisplayed()
        webView.paragraph.assertIsDisplayed()
    }
    
    func disabled_test___map() {
        open(screen: pageObjects.nonViewElementsTestsMapView)
            .waitUntilViewIsLoaded()
        
        mapView.pin.assertIsDisplayed()
    }
    
    func disabled_test___customDrawing() {
        open(screen: pageObjects.nonViewElementsTestsCustomDrawingView)
            .waitUntilViewIsLoaded()
        
        customDrawingView.element0.tap()
        customDrawingView.element0.assertMatches {
            $0.accessibilityValue == "1"
        }
        
        customDrawingView.element1.tap()
        customDrawingView.element1.assertMatches {
            $0.accessibilityValue == "1"
        }
        
        customDrawingView.element2.tap()
        customDrawingView.element2.assertMatches {
            $0.accessibilityValue == "1"
        }
    }
}
