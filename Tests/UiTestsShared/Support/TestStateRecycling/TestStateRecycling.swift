import MixboxFoundation

// Enables fast execution of tests with same precondition.
final class TestStateRecycling {
    static let instance = TestStateRecycling()
    private var stateByFileLineByTestCaseTypeName = [String: [FileLine: Any]]()
    
    func reuseState<T>(testCase: TestCase.Type, fileLine: FileLine, block: () -> (T)) -> T {
        let state: T
        let testCaseTypeName = "\(testCase)"
        
        if let reusedState = stateByFileLineByTestCaseTypeName[testCaseTypeName]?[fileLine] as? T {
            state = reusedState
        } else {
            state = block()
            
            if stateByFileLineByTestCaseTypeName[testCaseTypeName] == nil {
                stateByFileLineByTestCaseTypeName[testCaseTypeName] = [:]
            }
            
            stateByFileLineByTestCaseTypeName[testCaseTypeName]?[fileLine] = state
        }
        
        return state
    }
}
