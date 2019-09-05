import TestsIpc
import MixboxFoundation

// Returns tuples of UIEvent if there are exactly that many events.
extension BaseTouchesTestCase {
    func singleEvent() throws -> UiEvent {
        try requireNumberOfEvents(equals: 1)
        
        return try getEventHistory().uiEventHistoryRecords[0].event
    }
    
    func firstEvent() throws -> UiEvent {
        try requireNumberOfEvents(greaterThanOrEqualTo: 1)
        
        return try getEventHistory().uiEventHistoryRecords.first.unwrapOrFail().event
    }
    
    func lastEvent() throws -> UiEvent {
        try requireNumberOfEvents(greaterThanOrEqualTo: 1)
        
        return try getEventHistory().uiEventHistoryRecords.last.unwrapOrFail().event
    }
    
    func allEvents() throws -> (UiEvent, UiEvent) {
        try requireNumberOfEvents(equals: 2)
        
        return (
            try getEventHistory().uiEventHistoryRecords[0].event,
            try getEventHistory().uiEventHistoryRecords[1].event
        )
    }
    
    func allEvents() throws -> [UiEvent] {
        return try getEventHistory().uiEventHistoryRecords.map { $0.event }
    }
    
    func requireNumberOfEvents(equals expectedCount: Int) throws {
        try requireNumberOfEvents(
            matches: { $0 == expectedCount },
            mismatchDescription: { actualCount in
                "Expected exactly \(expectedCount) touch events, got \(actualCount)"
            }
        )
    }
    
    func requireNumberOfEvents(greaterThanOrEqualTo expectedCount: Int) throws {
        try requireNumberOfEvents(
            matches: { $0 >= expectedCount },
            mismatchDescription: { actualCount in
                "Expected \(expectedCount) or more touch events, got \(actualCount)"
            }
        )
    }
    
    func requireNumberOfEvents(
        matches matcher: (_ actualCount: Int) -> Bool,
        mismatchDescription: (_ actualCount: Int) -> String)
        throws
    {
        let actualCount = try getEventHistory().uiEventHistoryRecords.count
        
        if !matcher(actualCount) {
            throw ErrorString(mismatchDescription(actualCount))
        }
    }
}
