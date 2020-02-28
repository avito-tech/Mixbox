import MixboxIpc
import TestsIpc
import XCTest

extension BaseUiTestCase {
    func resetUi() {
        do {
            try ipcClient.callOrFail(method: ResetUiIpcMethod<IpcVoid>()).getVoidReturnValue()
        } catch {
            XCTFail("Error calling ResetUiIpcMethod: \(error)")
        }
    }
    
    func resetUi<ArgumentType: Codable>(argument: ArgumentType) {
        do {
            try ipcClient.callOrFail(method: ResetUiIpcMethod<ArgumentType>(), arguments: argument).getVoidReturnValue()
        } catch {
            XCTFail("Error calling ResetUiIpcMethod: \(error)")
        }
    }
}
