#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpcCommon
import MixboxIpc
import MixboxFoundation

final class GetUiEventHistoryIpcMethodHandler: IpcMethodHandler {
    let method = GetUiEventHistoryIpcMethod()
    
    private let uiEventHistoryProvider: UiEventHistoryProvider
    private let uiEventObserverFeatureToggleValueGetter: UiEventObserverFeatureToggleValueGetter
    
    init(
        uiEventHistoryProvider: UiEventHistoryProvider,
        uiEventObserverFeatureToggleValueGetter: UiEventObserverFeatureToggleValueGetter)
    {
        self.uiEventHistoryProvider = uiEventHistoryProvider
        self.uiEventObserverFeatureToggleValueGetter = uiEventObserverFeatureToggleValueGetter
    }
    
    func handle(
        arguments: GetUiEventHistoryIpcMethod.Arguments,
        completion: @escaping (GetUiEventHistoryIpcMethod.ReturnValue) -> ())
    {
        if uiEventObserverFeatureToggleValueGetter.isUiEventObserverFeatureEnabled {
            DispatchQueue.main.async { [uiEventHistoryProvider] in
                let uiEventHistory = uiEventHistoryProvider.uiEventHistory(since: arguments.sinceDate)
                completion(.returned(uiEventHistory))
            }
        } else {
            completion(
                .threw(
                    ErrorString(
                        """
                        UiEventHistoryProvider can not return history: feature is not enabled. \
                        See `SetUiEventHistoryTrackerEnabledIpcMethod`
                        """
                    )
                )
            )
        }
    }
}

#endif
