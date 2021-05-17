import MixboxMocksRuntime
import XCTest

final class RecordedCallsHolderImplTests: TestCase {
    private let holder = RecordedCallsHolderImpl()
    private let recordedCall = RecordedCall(
        functionIdentifier: "functionIdentifier",
        arguments: RecordedCallArguments(arguments: [])
    )
    
    override var reuseState: Bool {
        false
    }
    
    func test___recorded_calls___are_empty___initially() {
        XCTAssertEqual(
            holder.modifyRecordedCalls { _ in },
            []
        )
        XCTAssertEqual(
            holder.recordedCalls,
            []
        )
    }
    
    func test___modifyRecordedCalls___modifies_recorded_calls() {
        XCTAssertEqual(
            holder.modifyRecordedCalls { calls in
                calls.append(recordedCall)
            },
            [recordedCall]
        )
        
        XCTAssertEqual(
            holder.recordedCalls,
            [recordedCall]
        )
    }
}
