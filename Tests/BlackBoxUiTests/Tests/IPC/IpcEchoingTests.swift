import MixboxUiTestsFoundation
import MixboxIpc
import XCTest
import MixboxFoundation

class IpcEchoingTests: TestCase {
    func test_0_0() {
        checkEchoingValue(
            value: "string",
            useBuiltinIpc: false
        )
    }
    
    func test_0_1() {
        checkEchoingValue(
            value: "string",
            useBuiltinIpc: true
        )
    }
    
    func test_1_0() {
        checkEchoingValue(
            value: "������",
            useBuiltinIpc: false
        )
    }
    
    func test_1_1() {
        checkEchoingValue(
            value: "������",
            useBuiltinIpc: true
        )
    }
    
    func test_2_0() {
        checkEchoingValue(
            value: -12345,
            useBuiltinIpc: false
        )
    }
    
    func test_2_1() {
        checkEchoingValue(
            value: -12345,
            useBuiltinIpc: true
        )
    }
    
    func test_3_0() {
        checkEchoingValue(
            value: IpcVoid(),
            useBuiltinIpc: false
        )
    }
    
    func test_3_1() {
        checkEchoingValue(
            value: IpcVoid(),
            useBuiltinIpc: true
        )
    }
    
    func test_4_0() {
        checkEchoingValue(
            value: true,
            useBuiltinIpc: false
        )
    }
    
    func test_4_1() {
        checkEchoingValue(
            value: true,
            useBuiltinIpc: true
        )
    }
    
    func test_5_0() {
        checkEchoingValue(
            value: false,
            useBuiltinIpc: false
        )
    }
    
    func test_5_1() {
        checkEchoingValue(
            value: false,
            useBuiltinIpc: true
        )
    }
    
    func test_6_0() {
        checkEchoingValue(
            value: ["string"],
            useBuiltinIpc: false
        )
    }
    
    func test_6_1() {
        checkEchoingValue(
            value: ["string"],
            useBuiltinIpc: true
        )
    }
    
    func test_7_0() {
        checkEchoingValue(
            value: ["������"],
            useBuiltinIpc: false
        )
    }
    
    func test_7_1() {
        checkEchoingValue(
            value: ["������"],
            useBuiltinIpc: true
        )
    }
    
    // TODO:
    func disabled_test_8_0() {
        checkEchoingValue(
            value: nil as Int?,
            useBuiltinIpc: false
        )
    }
    
    // TODO:
    func disabled_test_8_1() {
        checkEchoingValue(
            value: nil as Int?,
            useBuiltinIpc: true
        )
    }
    
    // TODO:
    func disabled_test_9_0() {
        checkEchoingValue(
            value: Double.infinity,
            useBuiltinIpc: false
        )
    }
    
    // TODO:
    func disabled_test_9_1() {
        checkEchoingValue(
            value: Double.infinity,
            useBuiltinIpc: true
        )
    }
    
    // TODO:
    func disabled_test_10_0() {
        checkEchoingValue(
            value: Double.nan,
            useBuiltinIpc: false
        )
    }

    // TODO:
    func disabled_test_10_1() {
        checkEchoingValue(
            value: Double.nan,
            useBuiltinIpc: true
        )
    }
    
    // TODO:
    func disabled_test_11_0() {
        checkEchoingValue(
            value: -Double.infinity,
            useBuiltinIpc: false
        )
    }
    
    // TODO:
    func disabled_test_11_1() {
        checkEchoingValue(
            value: -Double.infinity,
            useBuiltinIpc: true
        )
    }
    
    private func checkEchoingValue<T: Equatable & Codable>(value: T, useBuiltinIpc: Bool, file: StaticString = #file, line: UInt = #line) {
        launch(environment: [:], useBuiltinIpc: useBuiltinIpc)
        
        let result: DataResult<T, IpcClientError> = ipcClient.call(
            method: EchoIpcMethod<T>(),
            arguments: value
        )
        
        XCTAssertEqual(
            result.data,
            value,
            "Failed. Expected \(value), received \(result.data.flatMap { "\($0)" } ?? "error: \(result.error!)"), useBuiltinIpc: \(useBuiltinIpc)",
            file: file,
            line: line
        )
    }
}

extension IpcVoid: Equatable {
    public static func ==(_: IpcVoid, _: IpcVoid) -> Bool {
        return true
    }
}
