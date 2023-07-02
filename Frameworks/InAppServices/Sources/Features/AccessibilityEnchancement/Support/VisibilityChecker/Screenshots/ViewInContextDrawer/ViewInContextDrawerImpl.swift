#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public final class ViewInContextDrawerImpl: ViewInContextDrawer {
    public init() {
        
    }
    
    public func draw(view: UIView, context: CGContext, afterScreenUpdates: Bool) {
        if isAlertWindowThatForSomeReasonDoesntRenderCorrectly(view: view) {
            view.layer.render(in: context)
        } else {
            let success: Bool = view.drawHierarchy(in: view.bounds, afterScreenUpdates: afterScreenUpdates)
            if !success {
                // TODO: Better error handling?
                print("Failed to drawViewHierarchyInRect for top level view: \(view)")
            }
        }
    }
    
    // TODO: Write E2E test. This logic is intricate. Also, now, I (the author) don't know why it was addded.
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
