import MixboxUiTestsFoundation
import MixboxIpc
import XCTest
import MixboxFoundation
import MixboxBuiltinIpc

// NOTE: IpcCallback is an experimental feature.
class IpcCallbacksTests: TestCase {
    override func precondition() {
        launch(environment: [:], useBuiltinIpc: true)
    }
    
    func test_incoming() {
        let result: DataResult<String?, IpcClientError> = ipcClient.call(
            method: CallbackToAppIpcMethod<Int, String>(),
            arguments: CallbackToAppIpcMethod<Int, String>.Arguments(
                value: 4,
                callback: .async { args, completion in
                    completion(String("\(args)"))
                }
            )
        )
        
        guard let data = result.data else {
            return XCTFail("result is error: \(result)")
        }
        
        XCTAssertEqual(data, "4")
    }
    
    func test_outgoing() {
        let callback: IpcCallback<Int, [Int]> = ipcClient.callOrFail(
            method: CallbackFromAppIpcMethod<Int>(),
            arguments: 4
        )
        
        var result: [Int]?
        
        callback.call(arguments: 2) { res in
            result = res.data
        }
        
        sleep(1)
        
        XCTAssertEqual(result, [4, 2])
    }
    
    func test_nestedCallbacks() {
        var calls = [Int]()
        
        let sleepInterval: TimeInterval = 0.1
        
        _ = ipcClient.callOrFail(
            method: NestedCallbacksToAppIpcMethod(),
            arguments: NestedCallbacksToAppIpcMethod.Arguments(
                sleepInterval: sleepInterval,
                callback: .async { _, completion in
                    calls.append(1)
                    Thread.sleep(forTimeInterval: sleepInterval)
                    completion(
                        .async { _, completion in
                            calls.append(2)
                            completion(IpcVoid())
                        }
                    )
                }
            )
        )
        
        Thread.sleep(forTimeInterval: 1)
        
        XCTAssertEqual(calls, [1, 2])
    }
}
