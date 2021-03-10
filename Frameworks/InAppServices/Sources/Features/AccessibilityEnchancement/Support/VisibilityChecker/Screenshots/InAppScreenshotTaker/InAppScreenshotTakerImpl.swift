#if MIXBOX_ENABLE_IN_APP_SERVICES

// Translated from Objective-C to Swift. Code is from EarlGrey.
// https://github.com/google/EarlGrey/blob/87ffa7ac2517cc8931e4e6ba11714961cbac6dd7/EarlGrey/Common/GREYScreenshotUtil.m
public final class InAppScreenshotTakerImpl: InAppScreenshotTaker  {
    private let screenInContextDrawer: ScreenInContextDrawer
    
    public init(
        screenInContextDrawer: ScreenInContextDrawer)
    {
        self.screenInContextDrawer = screenInContextDrawer
    }
    
    public func takeScreenshot(afterScreenUpdates: Bool) -> UIImage? {
        return image { context in
            screenInContextDrawer.drawScreen(
                context: context,
                afterScreenUpdates: afterScreenUpdates
            )
        }
    }
    
    private func image(configureContext: (CGContext) -> ()) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            screenInContextDrawer.screenBounds().size, // size
            true, // opaque
            screenInContextDrawer.screenScale() // scale
        )
        
        guard let context = UIGraphicsGetCurrentContext() else {
            // TODO: Handle error?
            return nil
        }
        
        configureContext(context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

#endif
