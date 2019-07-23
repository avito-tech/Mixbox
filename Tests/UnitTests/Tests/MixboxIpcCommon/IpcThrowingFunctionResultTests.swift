import Foundation
import MixboxTestsFoundation
import MixboxIpcCommon
import MixboxIpc
import MixboxFoundation

final class IpcThrowingFunctionResultTests: TestCase {
    func test___serialization___if_case_is_returned() {
        let result = IpcThrowingFunctionResult.returned(IpcVoid())
        
        checkSerialization(result)
    }
    
    func test___serialization___if_case_is_threw() {
        let result = IpcThrowingFunctionResult<IpcVoid>.threw(ErrorString("error text"))
        
        checkSerialization(result)
    }
}
