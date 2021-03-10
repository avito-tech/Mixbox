#if MIXBOX_ENABLE_IN_APP_SERVICES

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
