import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import XCTest
import MixboxFoundation
import TestsIpc

// You can generate tests using command:
// ```
// for i in {0..7}; do echo "func test_$i() { base_test_$i() }"; done
// ```
class BaseIpcEchoingTests: TestCase {
    var useBuiltinIpc: Bool {
        UnavoidableFailure.fail(
            """
            useBuiltinIpc is not implemented in a descendant of \
            \(BaseIpcEchoingTests.self): \(type(of: self))
            """
        )
    }
    
    override func precondition() {
        super.precondition()
        
        launch(environment: [:], useBuiltinIpc: useBuiltinIpc)
    }
    
    // Base tests
    
    func base_test_0() {
        checkEchoing(value: "string")
    }
    
    func base_test_1() {
        checkEchoing(value: "������")
    }
    
    func base_test_2() {
        checkEchoing(value: -12345)
    }
    
    func base_test_3() {
        checkEchoing(value: IpcVoid())
    }
    
    func base_test_4() {
        checkEchoing(value: true)
    }
    
    func base_test_5() {
        checkEchoing(value: false)
    }
    
    func base_test_6() {
        checkEchoing(value: ["string"])
    }
    
    func base_test_7() {
        checkEchoing(value: ["������"])
    }
    
    // Doesn't work
    func base_test_8() {
        checkEchoing(value: nil as Int?)
    }
    
    // Doesn't work
    func base_test_9() {
        checkEchoing(value: Double.infinity)
    }
    
    // Doesn't work
    func base_test_10() {
        checkEchoing(value: Double.nan)
    }
    
    // Doesn't work
    func base_test_11() {
        checkEchoing(value: -Double.infinity)
    }
    
    // Functions
    
    func checkEchoing<T: Equatable & Codable>(value: T, file: StaticString = #file, line: UInt = #line) {
        let result: DataResult<T, IpcClientError> = ipcClient.call(
            method: EchoIpcMethod<T>(),
            arguments: value
        )
        
        XCTAssertEqual(
            result.data,
            value,
            "Failed. Expected \(value), received \(result.data.flatMap { "\($0)" } ?? "error: \(result.error.unwrapOrFail())"), useBuiltinIpc: \(useBuiltinIpc)",
            file: file,
            line: line
        )
    }
}
