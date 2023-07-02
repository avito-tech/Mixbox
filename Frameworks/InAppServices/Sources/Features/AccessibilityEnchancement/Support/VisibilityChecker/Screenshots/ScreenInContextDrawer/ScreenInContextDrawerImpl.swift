#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxUiKit

public final class ScreenInContextDrawerImpl: ScreenInContextDrawer {
    private let orderedWindowsProvider: OrderedWindowsProvider
    private let viewInContextDrawer: ViewInContextDrawer
    private let screenInContextDrawerWindowPatcher: ScreenInContextDrawerWindowPatcher
    private let screen: UIScreen
    
    public init(
        orderedWindowsProvider: OrderedWindowsProvider,
        viewInContextDrawer: ViewInContextDrawer,
        screenInContextDrawerWindowPatcher: ScreenInContextDrawerWindowPatcher,
        screen: UIScreen
    ) {
        self.orderedWindowsProvider = orderedWindowsProvider
        self.viewInContextDrawer = viewInContextDrawer
        self.screenInContextDrawerWindowPatcher = screenInContextDrawerWindowPatcher
        self.screen = screen
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
    ) throws {
        let screenRect = screen.bounds
        
        // The bitmap context width and height are scaled, so we need to undo the scale adjustment.
        let contextWidth: CGFloat = CGFloat(context.width) / screen.scale
        let contextHeight: CGFloat = CGFloat(context.height) / screen.scale
        let xOffset: CGFloat = (contextWidth - screenRect.size.width) / 2
        let yOffset: CGFloat = (contextHeight - screenRect.size.height) / 2
        
        for view in try topLevelViewsInRenderingOrderSkippingInvisible() {
            context.saveGState()
            
            let viewRect: CGRect = view.bounds
            let viewCenter: CGPoint = view.center
            let viewAnchor: CGPoint = view.layer.anchorPoint
            
            context.translateBy(x: viewCenter.x + xOffset, y: viewCenter.y + yOffset)
            context.concatenate(view.transform)
            context.translateBy(x: -viewRect.width * viewAnchor.x, y: -viewRect.height * viewAnchor.y)
            
            viewInContextDrawer.draw(
                view: view,
                context: context,
                afterScreenUpdates: afterScreenUpdates
            )
            
            context.restoreGState()
        }
    }
    
    private func topLevelViewsInRenderingOrderSkippingInvisible() throws -> [UIView] {
        return try screenInContextDrawerWindowPatcher.patchWindowsForDrawing(
            windows: orderedWindowsProvider
                .windowsFromBottomMostToTopMost()
                .filter { !isDefinitelyNotVisible(window: $0) }
        )
    }
    
    private func isDefinitelyNotVisible(window: UIWindow) -> Bool {
        return window.isHidden
            || window.alpha == 0
            || window.frame.mb_hasZeroArea()
    }
}

#endif
