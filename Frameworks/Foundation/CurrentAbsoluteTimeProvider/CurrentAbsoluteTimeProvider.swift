#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol CurrentAbsoluteTimeProvider: class {
    func currentAbsoluteTime() -> AbsoluteTime
}

#endif
