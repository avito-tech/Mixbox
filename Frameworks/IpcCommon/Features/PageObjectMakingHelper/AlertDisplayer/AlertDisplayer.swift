#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol AlertDisplayer {
    func display(alert: Alert) throws
}

#endif
