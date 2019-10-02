import MixboxUiTestsFoundation
import MixboxFoundation

// Translated from Objective-C to Swift. Code is from EarlGrey.
// https://github.com/google/EarlGrey/blob/87ffa7ac2517cc8931e4e6ba11714961cbac6dd7/EarlGrey/Common/GREYScreenshotUtil.m
public final class GrayScreenshotTaker: ScreenshotTaker {
    private let windowsProvider: WindowsProvider
    private let screen: UIScreen
    
    public init(
        windowsProvider: WindowsProvider,
        screen: UIScreen)
    {
        self.windowsProvider = windowsProvider
        self.screen = screen
    }
    
    public func takeScreenshot() -> UIImage? {
        return takeScreenshot(afterScreenUpdates: true)
    }
    
    private func takeScreenshot(afterScreenUpdates: Bool) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(screen.bounds.size, _: true, _: screen.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            // TODO: Handle error?
            return nil
        }
        
        drawScreen(
            context: context,
            afterScreenUpdates: afterScreenUpdates
        )
        
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return screenshot
    }
    
    private func drawScreen(context: CGContext, afterScreenUpdates: Bool) {
        let screenRect = screen.bounds
        
        // The bitmap context width and height are scaled, so we need to undo the scale adjustment.
        let contextWidth: CGFloat = CGFloat(context.width) / screen.scale
        let contextHeight: CGFloat = CGFloat(context.height) / screen.scale
        let xOffset: CGFloat = (contextWidth - screenRect.size.width) / 2
        let yOffset: CGFloat = (contextHeight - screenRect.size.height) / 2
        
        for window in windowsInRenderingOrderSkippingInvisible() {
            context.saveGState()
            
            let windowRect: CGRect = window.bounds
            let windowCenter: CGPoint = window.center
            let windowAnchor: CGPoint = window.layer.anchorPoint
            
            context.translateBy(x: windowCenter.x + xOffset, y: windowCenter.y + yOffset)
            context.concatenate(window.transform)
            context.translateBy(x: -windowRect.width * windowAnchor.x, y: -windowRect.height * windowAnchor.y)
            
            if isAlertWindowThatForSomeReasonDoesntRenderCorrectly(window: window) {
                window.layer.render(in: context)
            } else {
                let success: Bool = window.drawHierarchy(in: windowRect, afterScreenUpdates: afterScreenUpdates)
                if !success {
                    // TODO: Better error handling?
                    print("Failed to drawViewHierarchyInRect for window: \(window)")
                }
            }
            
            context.restoreGState()
        }
    }
    
    private func windowsInRenderingOrderSkippingInvisible() -> [UIWindow] {
        return windowsProvider
            .windowsFromBottomMostToTopMost()
            .filter { window in !isDefinitelyNotVisible(window: window) }
    }
    
    private func isDefinitelyNotVisible(window: UIWindow) -> Bool {
        return window.isHidden
            || window.alpha == 0
            || window.frame.mb_hasZeroArea()
    }
    
    // TODO: Write test. This logic is intricate.
    private func isAlertWindowThatForSomeReasonDoesntRenderCorrectly(window: UIWindow) -> Bool {
        let alertWindowClassNames = [
            "_UIAlertControllerShimPresenterWindow",
            "_UIModalItemHostingWindow"
        ]
        
        for className in alertWindowClassNames {
            if let windowClass = NSClassFromString(className) {
                if window.isKind(of: windowClass) {
                    return true
                }
            }
        }
        
        return false
    }
}
