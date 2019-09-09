import TestsIpc
import MixboxFoundation

// Returns tuples of UIEvent if there are exactly that many events.
extension BaseTouchesTestCase {
    func singleTouch(_ event: UiEvent) throws -> UiTouch {
        try require(numberOfTouches: 1, event: event)
        
        return event.allTouches[0]
    }
    
    func allTouches(_ event: UiEvent) throws -> (UiTouch, UiTouch) {
        try require(numberOfTouches: 2, event: event)
        
        return (
            event.allTouches[0],
            event.allTouches[1]
        )
    }
    
    func require(numberOfTouches: Int, event: UiEvent) throws {
        let actualCount = event.allTouches.count
        
        if actualCount != numberOfTouches {
            throw ErrorString("Expected exactly \(numberOfTouches) touches in event \(event), got \(actualCount)")
        }
    }
}
