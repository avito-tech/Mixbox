#if MIXBOX_ENABLE_IN_APP_SERVICES

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
