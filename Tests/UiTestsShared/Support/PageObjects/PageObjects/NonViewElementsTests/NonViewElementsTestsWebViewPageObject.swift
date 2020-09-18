import Foundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation

public final class NonViewElementsTestsWebViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "NonViewElementsTestsWebView"
    
    public var header: LabelElement {
        return element("Header") { element in
            element.text == "Text of the header" && element.type == .staticText
        }
    }
    
    public var paragraph: LabelElement {
        return element("Paragraph") { element in
            element.text == "Text of the paragraph" && element.type == .staticText
        }
    }
}
