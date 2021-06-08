#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol DateProvider: AnyObject {
    func currentDate() -> Date
}

#endif
