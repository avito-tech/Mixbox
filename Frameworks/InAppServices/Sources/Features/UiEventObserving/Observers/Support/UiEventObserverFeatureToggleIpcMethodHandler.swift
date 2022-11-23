#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpcCommon
import MixboxIpc
import MixboxFoundation

public final class UiEventObserverFeatureToggleIpcMethodHandler<M>:
    IpcMethodHandler
    where
    M: IpcMethod,
    M.Arguments == Bool,
    M.ReturnValue == IpcThrowingFunctionResult<IpcVoid>
{
    public let method: M
    
    private let uiEventObserverFeatureToggleValueSetter: UiEventObserverFeatureToggleValueSetter
    
    public init(
        method: M,
        uiEventObserverFeatureToggleValueSetter: UiEventObserverFeatureToggleValueSetter)
    {
        self.method = method
        self.uiEventObserverFeatureToggleValueSetter = uiEventObserverFeatureToggleValueSetter
    }
    
    public func handle(
        arguments: M.Arguments,
        completion: @escaping (M.ReturnValue) -> ())
    {
        let isEnabled = arguments
        
        DispatchQueue.main.async { [uiEventObserverFeatureToggleValueSetter] in
            completion(
                IpcThrowingFunctionResult.void {
                    try uiEventObserverFeatureToggleValueSetter.setUiEventObserverFeatureEnabled(value: isEnabled)
                }
            )
        }
    }
}

#endif
