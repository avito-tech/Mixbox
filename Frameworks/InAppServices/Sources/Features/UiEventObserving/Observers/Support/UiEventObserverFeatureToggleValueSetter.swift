#if MIXBOX_ENABLE_IN_APP_SERVICES

// See also: `UiEventObserverFeatureToggleValueGetter`
//
public protocol UiEventObserverFeatureToggleValueSetter {
    func setUiEventObserverFeatureEnabled(value: Bool) throws
}

#endif
