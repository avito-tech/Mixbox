#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

import MixboxFoundation
#if SWIFT_PACKAGE
import MixboxIoKitObjc
#endif

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
