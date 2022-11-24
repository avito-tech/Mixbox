#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public protocol VisibilityCheckImagesCapturer {
    // Captures the visibility check's before and after image for the given `view` and loads the pixel
    // data into the `beforeImage` and `afterImage` of the return value
    //
    // `beforeImage` is just a plain image of view.
    // `afterImage` is generated using this teqnique:
    // - all colors are shifted
    // - view is rendered in the app
    // - screenshot is taken
    // - colors of screenshot are shifted back.
    //
    // So if view is not overlapped by anything, `beforeImage` and `afterImage` should be equal.
    //
    func capture(
        view: UIView,
        searchRectInScreenCoordinates: CGRect,
        targetPointOfInteraction: CGPoint?,
        visibilityCheckForLoopOptimizer: VisibilityCheckForLoopOptimizer)
        throws
        -> VisibilityCheckImagesCaptureResult
}

#endif
