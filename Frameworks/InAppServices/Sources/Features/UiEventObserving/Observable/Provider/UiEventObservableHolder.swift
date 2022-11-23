#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation

public final class UiEventObservableHolder: UiEventObservableProvider, UiEventObservableSetter {
    private var storedUiEventObservable: UiEventObservable?
    
    public init() {
    }
    
    public func uiEventObservable() throws -> UiEventObservable {
        if let storedUiEventObservable = storedUiEventObservable {
            return storedUiEventObservable
        } else {
            throw ErrorString("UiEventObservable was not set")
        }
    }
    
    public func set(uiEventObservable: UiEventObservable) {
        self.storedUiEventObservable = uiEventObservable
    }
}

#endif
