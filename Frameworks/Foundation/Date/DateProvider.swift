#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol DateProvider: class {
    func currentDate() -> Date
}

#endif
