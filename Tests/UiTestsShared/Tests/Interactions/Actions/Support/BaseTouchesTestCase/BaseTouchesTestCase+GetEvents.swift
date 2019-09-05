import TestsIpc

extension BaseTouchesTestCase {
    func getUiEventsViaIpc(body: () -> ()) -> UiEventHistory {
        let sinceDate = Date()
        
        func getEvents() -> UiEventHistory {
            return ipcClient.callOrFail(
                method: GetUiEventHistoryIpcMethod(),
                arguments: sinceDate
            )
        }
        
        body()
        
        var eventsAfter: UiEventHistory?
        
        waiter.wait(
            timeout: 5,
            interval: 0.5,
            until: {
                let currentEvents = getEvents()
                
                if !currentEvents.uiEventHistoryRecords.isEmpty {
                    // Got some new events
                    eventsAfter = currentEvents
                    return true
                } else {
                    return false
                }
            }
        )
        
        return eventsAfter ?? getEvents()
    }
}
