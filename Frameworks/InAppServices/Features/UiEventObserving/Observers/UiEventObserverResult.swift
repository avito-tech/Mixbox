#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class UiEventObserverResult {
    // Consider using `false`.
    // `false`: event will be forwarded to UIWindow as usual
    // `true`: event should not be forwarded to UIWindow, it will be consumed, app wouldn't react to UIEvent.
    //         for example, if there is some testing UI above real app UI and you don't want app to react.
    public let shouldConsumeEvent: Bool
    
    public init(shouldConsumeEvent: Bool) {
        self.shouldConsumeEvent = shouldConsumeEvent
    }
}

#endif
