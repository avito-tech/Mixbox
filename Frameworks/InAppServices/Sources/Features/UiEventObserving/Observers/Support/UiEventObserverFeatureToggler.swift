#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public final class UiEventObserverFeatureToggler:
    UiEventObserverFeatureToggleValueGetter,
    UiEventObserverFeatureToggleValueSetter
{
    private let uiEventObservableProvider: UiEventObservableProvider
    private let uiEventObserver: UiEventObserver
    
    public init(
        uiEventObservableProvider: UiEventObservableProvider,
        uiEventObserver: UiEventObserver)
    {
        self.uiEventObservableProvider = uiEventObservableProvider
        self.uiEventObserver = uiEventObserver
    }
    
    // MARK: - UiEventObserverFeatureToggler
    
    public var isUiEventObserverFeatureEnabled: Bool {
        do {
            let uiEventObservable = try uiEventObservableProvider.uiEventObservable()
            
            return uiEventObservable.contains(observer: uiEventObserver)
        } catch {
            return false
        }
    }
    
    public func setUiEventObserverFeatureEnabled(value: Bool) throws {
        let uiEventObservable = try uiEventObservableProvider.uiEventObservable()

        if value {
            uiEventObservable.add(observer: uiEventObserver)
        } else {
            uiEventObservable.remove(observer: uiEventObserver)
        }
    }
}

#endif
