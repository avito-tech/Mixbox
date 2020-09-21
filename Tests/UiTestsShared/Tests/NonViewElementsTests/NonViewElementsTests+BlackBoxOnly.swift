import XCTest
import TestsIpc
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxUiKit

// TODO (non-view elements): Support gray box testing.
//
//                           Webkit runs in other process, so there is no easy way to access accessibilty elements
//                           via API of WKWebView, but it seems that accessibility framework can access accessibility
//                           stuff of Web View from XCUI tests. Maybe there is a way to do exactly the same
//                           from Gray Box tests appication via some hacks, because XCUI tests is in fact also an iOS
//                           applications, maybe with some specific entitlements.
//
extension NonViewElementsTests {
    private var webView: NonViewElementsTestsWebViewPageObject {
        return pageObjects.nonViewElementsTestsWebView.default
    }
    
    func test___web() {
        open(screen: webView).waitUntilViewIsLoaded()
        
        // Webview is asynchronous, so we have to wait.
        webView.header.assertIsDisplayed()
        webView.paragraph.withoutTimeout.assertIsDisplayed()
    }
}
