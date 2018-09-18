import MixboxUiTestsFoundation
import MixboxIpc
import XCTest
import MixboxFoundation

class ScreenshotTests: TestCase {
    func test() {
        openScreen(name: "ScreenshotTestsView")
        
        pageObjects.screen.view(index: 0).assert.isDisplayed()
        
        for index in 0..<ScreenshotTestsConstants.viewsCount {
            let imageOrNil = UIImage.image(
                color: ScreenshotTestsConstants.color(index: index),
                size: ScreenshotTestsConstants.viewSize(index: index)
            )
            guard let image = imageOrNil else {
                XCTFail("Can not create image")
                return
            }
            pageObjects.screenXcui.view(index: index).withoutTimeout.assert.matchesReference(image: image)
            pageObjects.screen.view(index: index).withoutTimeout.assert.matchesReference(image: image)
        }
    }
}

private final class Screen: BasePageObjectWithDefaultInitializer {
    func view(index: Int) -> ViewElement {
        let id = ScreenshotTestsConstants.viewId(index: index)
        return element(id) { element in element.id == id }
    }
}

private extension PageObjects {
    var screen: Screen {
        return pageObject()
    }
    var screenXcui: Screen {
        return apps.mainXcui.pageObject()
    }
}
