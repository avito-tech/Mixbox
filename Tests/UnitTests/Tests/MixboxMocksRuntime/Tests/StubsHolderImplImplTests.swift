import MixboxMocksRuntime
import XCTest

final class StubsHolderImplImplTests: TestCase {
    private let holder = StubsHolderImpl()
    private let recordedCall = RecordedCall(
        functionIdentifier: "functionIdentifier",
        arguments: RecordedCallArguments(arguments: [])
    )
    
    override var reuseState: Bool {
        false
    }
    
    func test___stub___are_empty___initially() {
        XCTAssert(
            holder.modifyStubs { _ in }.isEmpty
        )
        XCTAssert(
            holder.stubs.isEmpty
        )
    }
    
    func test___modifyStubs___modifies_stubs() {
        XCTAssert(
            holder.modifyStubs { stubs in
                stubs["x"] = []
            }["x"].unwrapOrFail().isEmpty
        )
        
        XCTAssert(
            holder.stubs["x"].unwrapOrFail().isEmpty
        )
    }
}
