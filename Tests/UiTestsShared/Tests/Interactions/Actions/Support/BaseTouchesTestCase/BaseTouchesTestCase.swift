import MixboxFoundation
import MixboxIpcCommon

// TODO: Test press&drag. Check `duration` argument. And all other too.
// TODO: Test swipes. Check cancelling inertia (both on/off, search for `cancelInertia`).
class BaseTouchesTestCase: TestCase {
    var screen: TouchesTestsViewPageObject {
        return pageObjects.touchesTestsView.default
    }
    
    // MARK: - Lifecycle
    
    override func precondition() {
        super.precondition()
        
        open(screen: screen).waitUntilViewIsLoaded()
        
        synchronousIpcClient
            .callOrFail(method: SetUiEventHistoryTrackerEnabledIpcMethod(), arguments: true)
            .getVoidReturnValueOrFail()
    }
    
    // MARK: - Event history
    
    private var eventHistory: UiEventHistory?
    
    func recordUiEvents(waitingForEvents: Bool = true, body: () -> ()) {
        eventHistory = getUiEventsViaIpc(body: body)
    }
    
    func getEventHistory() throws -> UiEventHistory {
        guard let eventHistory = eventHistory else {
            throw ErrorString("eventHistory was not set")
        }
        
        return eventHistory
    }
}
