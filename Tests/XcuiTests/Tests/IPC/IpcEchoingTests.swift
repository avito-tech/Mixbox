import MixboxUiTestsFoundation
import MixboxIpc
import XCTest
import MixboxFoundation

class IpcEchoingTests: TestCase {
    func test_0() {
        checkEchoingValue("string")
    }
    
    func test_1() {
        checkEchoingValue("������")
    }
    
    func test_2() {
        checkEchoingValue(-12345)
    }
    
    func test_3() {
        checkEchoingValue(IpcVoid())
    }
    
    func test_4() {
        checkEchoingValue(true)
    }
    
    func test_5() {
        checkEchoingValue(false)
    }
    
    func test_6() {
        checkEchoingValue(["string"])
    }
    
    func test_7() {
        checkEchoingValue(["������"])
    }
    
    // TODO:
    func disabled_test_8() {
        checkEchoingValue(nil as Int?)
    }
    
    // TODO:
    func disabled_test_9() {
        checkEchoingValue(Double.infinity)
    }

    // TODO:
    func disabled_test_10() {
        checkEchoingValue(Double.nan)
    }
    
    // TODO:
    func disabled_test_11() {
        checkEchoingValue(-Double.infinity)
    }
    
    private func checkEchoingValue<T: Equatable & Codable>(_  value: T, file: StaticString = #file, line: UInt = #line) {
        for useBuiltinIpc in [false, true] {
            launch(environment: [:], useBuiltinIpc: useBuiltinIpc)
            
            let result: DataResult<T, IpcClientError> = testCaseUtils.lazilyInitializedIpcClient.call(
                method: EchoIpcMethod<T>(),
                arguments: value
            )
            
            XCTAssertEqual(
                result.data,
                value,
                "Failed. Expected \(value), received \(result.data.flatMap { "\($0)" } ?? "error"), useBuiltinIpc: \(useBuiltinIpc)",
                file: file,
                line: line
            )
        }
    }
}

extension IpcVoid: Equatable {
    public static func ==(_: IpcVoid, _: IpcVoid) -> Bool {
        return true
    }
}
