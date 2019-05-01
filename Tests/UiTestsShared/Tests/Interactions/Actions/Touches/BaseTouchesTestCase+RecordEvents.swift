import TestsIpc

extension BaseTouchesTestCase {
    func recordUiEvents(body: () -> ()) -> UiEventHistory {
        let sinceDate = Date()
        
        body()
        
        return ipcClient.callOrFail(
            method: GetUiEventHistoryIpcMethod(),
            arguments: sinceDate
        )
    }
}
