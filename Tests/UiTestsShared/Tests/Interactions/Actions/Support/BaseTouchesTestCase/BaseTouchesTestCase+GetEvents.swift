import MixboxIpcCommon

extension BaseTouchesTestCase {
    func getUiEventsViaIpc(body: () -> ()) -> UiEventHistory {
        let sinceDate = Date()
        
        func getEvents() -> UiEventHistory {
            let result = synchronousIpcClient.callOrFail(
                method: GetUiEventHistoryIpcMethod(),
                arguments: GetUiEventHistoryIpcMethod.Arguments(
                    sinceDate: sinceDate
                )
            )
            
            return result.getReturnValueOrFail()
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
