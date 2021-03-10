#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol UiEventObservable {
    func add(observer: UiEventObserver)
    func remove(observer: UiEventObserver)
    func contains(observer: UiEventObserver) -> Bool
}

#endif
