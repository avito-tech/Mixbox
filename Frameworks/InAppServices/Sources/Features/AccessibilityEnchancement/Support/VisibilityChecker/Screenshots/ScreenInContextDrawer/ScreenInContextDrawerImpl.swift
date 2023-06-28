#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxUiKit

public final class ScreenInContextDrawerImpl: ScreenInContextDrawer {
    private let orderedWindowsProvider: OrderedWindowsProvider
    private let screen: UIScreen
    private let iosVersionProvider: IosVersionProvider
    private let keyboardPrivateApi: KeyboardPrivateApi
    
    public init(
        orderedWindowsProvider: OrderedWindowsProvider,
        screen: UIScreen,
        iosVersionProvider: IosVersionProvider,
        keyboardPrivateApi: KeyboardPrivateApi
    ) {
        self.orderedWindowsProvider = orderedWindowsProvider
        self.screen = screen
        self.iosVersionProvider = iosVersionProvider
        self.keyboardPrivateApi = keyboardPrivateApi
    }
    
    public func screenScale() -> CGFloat {
        return screen.scale
    }
    
    public func screenBounds() -> CGRect {
        return screen.bounds
    }
    
    public func drawScreen(
        context: CGContext,
        afterScreenUpdates: Bool
    ) {
        let screenRect = screen.bounds
        
        // The bitmap context width and height are scaled, so we need to undo the scale adjustment.
        let contextWidth: CGFloat = CGFloat(context.width) / screen.scale
        let contextHeight: CGFloat = CGFloat(context.height) / screen.scale
        let xOffset: CGFloat = (contextWidth - screenRect.size.width) / 2
        let yOffset: CGFloat = (contextHeight - screenRect.size.height) / 2
        
        for view in topLevelViewsInRenderingOrderSkippingInvisible() {
            context.saveGState()
            
            let viewRect: CGRect = view.bounds
            let viewCenter: CGPoint = view.center
            let viewAnchor: CGPoint = view.layer.anchorPoint
            
            context.translateBy(x: viewCenter.x + xOffset, y: viewCenter.y + yOffset)
            context.concatenate(view.transform)
            context.translateBy(x: -viewRect.width * viewAnchor.x, y: -viewRect.height * viewAnchor.y)
            
            if isAlertWindowThatForSomeReasonDoesntRenderCorrectly(view: view) {
                view.layer.render(in: context)
            } else {
                let success: Bool = view.drawHierarchy(in: viewRect, afterScreenUpdates: afterScreenUpdates)
                if !success {
                    // TODO: Better error handling?
                    print("Failed to drawViewHierarchyInRect for top level view: \(view)")
                }
            }
            
            context.restoreGState()
        }
    }
    
    private func topLevelViewsInRenderingOrderSkippingInvisible() -> [UIView] {
        return orderedWindowsProvider
            .windowsFromBottomMostToTopMost()
            .filter { !isDefinitelyNotVisible(window: $0) }
            .map { replaceKeyboardWindowIfNeeded(window: $0) }
    }
    
    private func isDefinitelyNotVisible(window: UIWindow) -> Bool {
        return window.isHidden
            || window.alpha == 0
            || window.frame.mb_hasZeroArea()
    }
    
    // On iOS 16 there is a `UITextEffectsWindow` class that is not rendered on screenshots, however,
    // if we get root view of `_layout` of instance of `UIKeyboardImpl`, it can be drawn.
    private func replaceKeyboardWindowIfNeeded(window: UIWindow) -> UIView {
        guard iosVersionProvider.iosVersion().majorVersion >= 16 else {
            // Everything is fine below iOS 16
            return window
        }
        
        guard let textEffectsWindowClass = NSClassFromString("UITextEffectsWindow") else {
            return window
        }
        
        guard window.isKind(of: textEffectsWindowClass) else {
            return window
        }
        
        guard let keyboardLayout = keyboardPrivateApi.layout() else {
            return window
        }
        
        var viewPointer = keyboardLayout
        while let superview = viewPointer.superview {
            viewPointer = superview
        }
        
        let drawableKeyboardWindow = viewPointer
        
        guard let mainWindow = UIApplication.shared.windows.first else {
            return window
        }
        
        let frameOfMainWindowNotOverlappedByKeyboard = keyboardPrivateApi.subtractKeyboardFrame(
            rect: mainWindow.bounds,
            view: mainWindow
        )
        
        let keyboardIsHidden = frameOfMainWindowNotOverlappedByKeyboard == mainWindow.bounds
        
        if keyboardIsHidden {
            // This can happen when keyboard is just closed.
            // Layout is not nil for some reason. The `drawableKeyboardWindow` appears to be empty
            // in debugger, however, if drawn, the whole screenshot will look buggy/messy,
            // there will be a part of keyboard layout drawn on top (!) of the screen.
            return window
        } else {
            return drawableKeyboardWindow
        }
    }
    
    // TODO: Write test. This logic is intricate.
    private func isAlertWindowThatForSomeReasonDoesntRenderCorrectly(view: UIView) -> Bool {
        let alertWindowClassNames = [
            "_UIAlertControllerShimPresenterWindow",
            "_UIModalItemHostingWindow"
        ]
        
        for className in alertWindowClassNames {
            if let alertWindowClass = NSClassFromString(className) {
                if view.isKind(of: alertWindowClass) {
                    return true
                }
            }
        }
        
        return false
    }
}

#endif
