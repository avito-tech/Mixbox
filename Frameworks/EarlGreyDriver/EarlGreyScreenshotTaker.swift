import MixboxUiTestsFoundation
import EarlGrey

public final class EarlGreyScreenshotTaker: ScreenshotTaker {
    public init() {
    }
    
    public func takeScreenshot() -> UIImage? {
        return GREYScreenshotUtil.takeScreenshot()
    }
}
