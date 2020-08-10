#if MIXBOX_ENABLE_IN_APP_SERVICES

// NOTE: Can be reused for various feature toggling, however, let's keep
// the protocol restricted to a particular set of features until necessary.
// This is to prevent bad architectural decisions.
// For example, the setter for feature toggle is throwing.
// The names are long to avoid conflicts with multiple inheritance.
// See also: `UiEventObserverFeatureToggleValueSetter`.
//
public protocol UiEventObserverFeatureToggleValueGetter {
    var isUiEventObserverFeatureEnabled: Bool { get }
}

#endif
