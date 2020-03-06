#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol UiApplicationHandleIohidEventObservable: class {
    func add(uiApplicationHandleIohidEventObserver: UiApplicationHandleIohidEventObserver)
    func remove(uiApplicationHandleIohidEventObserver: UiApplicationHandleIohidEventObserver)
}

#endif
