#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public protocol InAppScreenshotTaker {
     func takeScreenshot(afterScreenUpdates: Bool) throws -> UIImage
}

extension InAppScreenshotTaker {
    public func takeScreenshot() throws -> UIImage {
        return try takeScreenshot(afterScreenUpdates: true)
    }
}

#endif
