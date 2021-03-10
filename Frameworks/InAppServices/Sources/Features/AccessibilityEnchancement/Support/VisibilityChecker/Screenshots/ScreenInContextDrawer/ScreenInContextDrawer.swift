#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol ScreenInContextDrawer {
    func screenScale() -> CGFloat
    func screenBounds() -> CGRect
    func drawScreen(context: CGContext, afterScreenUpdates: Bool)
}

#endif
