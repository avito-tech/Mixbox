import TestsIpc
import MixboxIpc

final class GetUiEventHistoryIpcMethodHandler: IpcMethodHandler {
    let method = GetUiEventHistoryIpcMethod()
    
    private let uiEventHistoryProvider: UiEventHistoryProvider
    
    init(uiEventHistoryProvider: UiEventHistoryProvider)  {
        self.uiEventHistoryProvider = uiEventHistoryProvider
    }
    
    func handle(
        arguments since: Date,
        completion: @escaping (UiEventHistory) -> ())
    {
        let uiEventHistory = uiEventHistoryProvider.uiEventHistory(since: since)
        
        completion(uiEventHistory)
    }
}
