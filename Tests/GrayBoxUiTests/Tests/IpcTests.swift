import MixboxUiTestsFoundation
import XCTest
import MixboxIpc
import MixboxFoundation
import TestsIpc

// TODO: Share code between black & gray box tests
final class IpcTests: BaseChecksTestCase {
    func test_0() {
        checkEchoingValue(
            value: "string",
            useBuiltinIpc: false
        )
    }
    
    func test_1() {
        checkEchoingValue(
            value: "������",
            useBuiltinIpc: false
        )
    }
    
    func test_2() {
        checkEchoingValue(
            value: -12345,
            useBuiltinIpc: false
        )
    }
    
    func test_3() {
        checkEchoingValue(
            value: IpcVoid(),
            useBuiltinIpc: false
        )
    }
    
    func test_4() {
        checkEchoingValue(
            value: true,
            useBuiltinIpc: false
        )
    }
    
    func test_5() {
        checkEchoingValue(
            value: false,
            useBuiltinIpc: false
        )
    }
    
    func test_6() {
        checkEchoingValue(
            value: ["string"],
            useBuiltinIpc: false
        )
    }
    
    func test_7() {
        checkEchoingValue(
            value: ["������"],
            useBuiltinIpc: false
        )
    }
    
    private func checkEchoingValue<T: Equatable & Codable>(value: T, useBuiltinIpc: Bool, file: StaticString = #file, line: UInt = #line) {
        let result: DataResult<T, IpcClientError> = synchronousIpcClient.call(
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
