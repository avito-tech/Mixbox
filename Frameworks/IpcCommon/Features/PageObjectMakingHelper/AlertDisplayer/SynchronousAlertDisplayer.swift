#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol SynchronousAlertDisplayer {
    func display(alert: Alert) throws
}

#endif
