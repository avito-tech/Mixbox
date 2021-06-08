#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol UiApplicationHandleIohidEventObservable: AnyObject {
    func add(uiApplicationHandleIohidEventObserver: UiApplicationHandleIohidEventObserver)
    func remove(uiApplicationHandleIohidEventObserver: UiApplicationHandleIohidEventObserver)
}

#endif
