#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
