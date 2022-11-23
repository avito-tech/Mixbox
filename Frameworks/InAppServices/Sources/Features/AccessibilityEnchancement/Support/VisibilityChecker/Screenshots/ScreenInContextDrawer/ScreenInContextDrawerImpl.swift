#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public final class ScreenInContextDrawerImpl: ScreenInContextDrawer {
    private let orderedWindowsProvider: OrderedWindowsProvider
    private let screen: UIScreen
    
    public init(
        orderedWindowsProvider: OrderedWindowsProvider,
        screen: UIScreen)
    {
        self.orderedWindowsProvider = orderedWindowsProvider
        self.screen = screen
    }
    
    public func screenScale() -> CGFloat {
        return screen.scale
    }
    
    public func screenBounds() -> CGRect {
        return screen.bounds
    }
    
    public func drawScreen(context: CGContext, afterScreenUpdates: Bool) {
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
        return orderedWindowsProvider
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

#endif
