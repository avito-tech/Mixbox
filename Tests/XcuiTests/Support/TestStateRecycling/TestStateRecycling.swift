import MixboxFoundation

// Enables fast execution of tests with same precondition.
final class TestStateRecycling {
    static let instance = TestStateRecycling()
    private var lastTestCase: TestCase.Type?
    private var stateByFileLine = [FileLine: Any]()
    
    func reuseState<T>(testCase: TestCase.Type, fileLine: FileLine, block: () -> (T)) -> T {
        let state: T
        
        if lastTestCase == testCase {
            if let reusedState = stateByFileLine[fileLine] as? T {
                state = reusedState
            } else {
                state = block()
                stateByFileLine[fileLine] = state
            }
        } else {
            state = block()
            stateByFileLine = [fileLine: state]
        }
        
        lastTestCase = testCase
        
        return state
    }
}
