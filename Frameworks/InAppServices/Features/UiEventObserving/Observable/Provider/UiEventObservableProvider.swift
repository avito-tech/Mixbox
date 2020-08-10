#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol UiEventObservableProvider {
    func uiEventObservable() throws -> UiEventObservable
}

#endif
