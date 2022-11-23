#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

public protocol UiApplicationHandleIohidEventObservable: AnyObject {
    func add(uiApplicationHandleIohidEventObserver: UiApplicationHandleIohidEventObserver)
    func remove(uiApplicationHandleIohidEventObserver: UiApplicationHandleIohidEventObserver)
}

#endif
