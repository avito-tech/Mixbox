#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol VisibilityChecker {
    func percentElementVisible(view: UIView) -> CGFloat
}

#endif
