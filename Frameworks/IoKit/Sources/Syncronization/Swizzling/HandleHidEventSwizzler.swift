#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol HandleHidEventSwizzler {
    func swizzle() -> UiApplicationHandleIohidEventObservable
}

#endif
