#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol InAppScreenshotTaker {
     func takeScreenshot(afterScreenUpdates: Bool) throws -> UIImage
}

extension InAppScreenshotTaker {
    public func takeScreenshot() throws -> UIImage {
        return try takeScreenshot(afterScreenUpdates: true)
    }
}

#endif
