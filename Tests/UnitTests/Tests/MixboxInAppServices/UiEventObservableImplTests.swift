import MixboxInAppServices
import XCTest

final class UiEventObservableImplTests: TestCase {
    func test___observable___calls_every_observer() {
        let firstObserver = observer()
        observable.add(observer: firstObserver)
        
        XCTAssertEqual(state.calls, 0)
        
        sendEvent()
        
        XCTAssertEqual(state.calls, 1)
        
        let secondObserver = observer()
        observable.add(observer: secondObserver)
        
        sendEvent()
        
        XCTAssertEqual(state.calls, 3)
    }
    
    func test___observable___removes_desstructed_observerss() {
        do {
            let temporaryObserver = observer()
            
            observable.add(observer: temporaryObserver)
            
            XCTAssertEqual(state.calls, 0)
            
            sendEvent()
            
            XCTAssertEqual(state.calls, 1)
        }
        
        sendEvent()
        
        XCTAssertEqual(state.calls, 1)
    }
    
    func test___add___doesnt_duplicate_observers() {
        let sameObserver = observer()
        
        observable.add(observer: sameObserver)
        observable.add(observer: sameObserver)
        
        XCTAssertEqual(state.calls, 0)
        
        sendEvent()
        
        XCTAssertEqual(state.calls, 1)
    }
    
    func test___remove___removes_observer_observers() {
        let sameObserver = observer()
        
        observable.add(observer: sameObserver)
        
        XCTAssertEqual(state.calls, 0)
        
        sendEvent()
        
        XCTAssertEqual(state.calls, 1)
        
        observable.remove(observer: sameObserver)
        
        sendEvent()
        
        XCTAssertEqual(state.calls, 1)
    }
    
    func test___contains() {
        let addedObserver = observer()
        let removedObserver = observer()
        let notAddedObserver = observer()
        
        observable.add(observer: addedObserver)
        
        observable.add(observer: removedObserver)
        observable.remove(observer: removedObserver)
        
        XCTAssertTrue(observable.contains(observer: addedObserver))
        XCTAssertFalse(observable.contains(observer: removedObserver))
        XCTAssertFalse(observable.contains(observer: notAddedObserver))
    }
    
    // MARK: - Private
    
    private class State {
        var calls = 0
    }
    
    private class Observer: UiEventObserver {
        let state: State
        
        init(state: State) {
            self.state = state
        }
        
        func eventWasSent(event: UIEvent, window: UIWindow) {
            state.calls += 1
        }
    }
    
    private let state = State()
    private let observable = UiEventObservableImpl()
    
    private func observer() -> Observer {
        return Observer(state: state)
    }
    
    private func sendEvent() {
        observable.eventWasSent(event: UIEvent(), window: UIWindow())
    }
}
