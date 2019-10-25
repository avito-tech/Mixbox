#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class SingletonHandleHidEventObserver:
    UiApplicationHandleIohidEventObservable
{
    public static let instance = SingletonHandleHidEventObserver()
    private var observersList = [WeakBox<UiApplicationHandleIohidEventObserver>]()
    
    private init() {}
    
    public func uiApplicationHandledIohidEvent(_ iohidEvent: IOHIDEventRef) {
        observersList.forEach {
            $0.value?.uiApplicationHandledIohidEvent(iohidEvent)
        }
        observersList.removeAll { $0.value == nil }
    }
    
    public func add(uiApplicationHandleIohidEventObserver: UiApplicationHandleIohidEventObserver) {
        observersList.append(WeakBox(uiApplicationHandleIohidEventObserver))
    }
    
    public func remove(uiApplicationHandleIohidEventObserver: UiApplicationHandleIohidEventObserver) {
        observersList.removeAll {
            $0.value === uiApplicationHandleIohidEventObserver || $0.value == nil
        }
    }
}

#endif
