import MixboxFoundation
import TestsIpc

// TODO: Test press&drag. Check `duration` argument. And all other too.
// TODO: Test swipes. Check cancelling inertia (both on/off, search for `cancelInertia`).
class BaseTouchesTestCase: TestCase {
    var openableScreen: MainAppScreen<TouchesTestsViewPageObject> {
        return pageObjects.touchesTestsView
    }
    
    func open() {
        openScreen(screen)
    }
    
    var screen: TouchesTestsViewPageObject {
        return openableScreen.real
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
