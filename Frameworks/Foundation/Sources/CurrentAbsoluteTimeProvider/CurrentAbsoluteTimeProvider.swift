#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol CurrentAbsoluteTimeProvider: AnyObject {
    func currentAbsoluteTime() -> AbsoluteTime
}

#endif
