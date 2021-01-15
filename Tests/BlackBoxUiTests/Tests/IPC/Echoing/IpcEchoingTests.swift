import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import XCTest
import MixboxFoundation
import TestsIpc

class IpcEchoingTests: TestCase {
    override func precondition() {
        super.precondition()
        
        launch(environment: [:])
    }
    
    // Base tests
    
    func test_0() {
        checkEchoing(value: "string")
    }
    
    func test_1() {
        checkEchoing(value: "������")
    }
    
    func test_2() {
        checkEchoing(value: -12345)
    }
    
    func test_3() {
        checkEchoing(value: IpcVoid())
    }
    
    func test_4() {
        checkEchoing(value: true)
    }
    
    func test_5() {
        checkEchoing(value: false)
    }
    
    func test_6() {
        checkEchoing(value: ["string"])
    }
    
    func test_7() {
        checkEchoing(value: ["������"])
    }
    
    // Doesn't work
    func test_8() {
        checkEchoing(value: nil as Int?)
    }
    
    // Doesn't work
    func test_9() {
        checkEchoing(value: Double.infinity)
    }
    
    // Doesn't work
    func test_10() {
        checkEchoing(value: Double.nan)
    }
    
    // Doesn't work
    func test_11() {
        checkEchoing(value: -Double.infinity)
    }
    
    // Functions
    
    func checkEchoing<T: Equatable & Codable>(value: T, file: StaticString = #file, line: UInt = #line) {
        let result: DataResult<T, IpcClientError> = synchronousIpcClient.call(
            method: EchoIpcMethod<T>(),
            arguments: value
        )
        
        XCTAssertEqual(
            result.data,
            value,
            "Failed. Expected \(value), received \(result.data.flatMap { "\($0)" } ?? "error: \(result.error.unwrapOrFail())")",
            file: file,
            line: line
        )
    }
}
