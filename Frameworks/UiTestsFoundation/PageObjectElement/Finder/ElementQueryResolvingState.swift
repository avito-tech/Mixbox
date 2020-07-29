import MixboxTestsFoundation

// The class is needed to collect all found `ElementSnapshot`s and to collect all `MatchingResult` (which can be used
// for example to say why no elements found or why matcher finds duplicate elements).
//
// How iot is used: elements are collected within closure of NSPredicate, which finds elements.
// Element are appended within `start()` and `stop()` calls.
//
// This class is needed because we can not get element hierarchy directly using XCUI.
// Using this kind of hack requires us to track access to certain properties of XCUIElement, which calls closure
// of `NSPredicate` that we pass to a private method of `XCUIElement` to not call it more than once and not spoil
// array of collected snapshots.
//
// TODO: Remove from MixboxGray, make it for MixboxXcui only.
// It is not needed for Real View Hierarchy, because we can get elements properly there.
public final class ElementQueryResolvingState {
    private(set) var matchingResults = [MatchingResult]()
    private(set) var matchingSnapshots = [ElementSnapshot]()
    private(set) var elementSnapshots = [ElementSnapshot]()
    
    // TODO: Throw error if properties are read while in `.undefined` or `.resolving` states.
    private enum State {
        case undefined
        case resolving
        case resolved
    }
    
    private var state: State = .undefined
    
    public init() {
    }
    
    public func start() {
        assert(state == .undefined, "ElementQueryResolvingState (\(self)) was used twice, it should not be reused")
        
        state = .resolving
    }
    
    public func stop() {
        state = .resolved
    }
    
    public func append(matchingResult: MatchingResult, elementSnapshot: ElementSnapshot) {
        switch state {
        case .resolving:
            matchingResults.append(matchingResult)
            elementSnapshots.append(elementSnapshot)
            
            switch matchingResult {
            case .match:
                matchingSnapshots.append(elementSnapshot)
            case .mismatch:
                break
            }
        case .resolved:
            break
        case .undefined:
            break
        }
    }
}
