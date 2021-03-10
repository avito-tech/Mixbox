import MixboxIpcCommon
import MixboxIpc
import MixboxTestsFoundation

extension IpcThrowingFunctionResult {
    public func getReturnValueOrFail() -> T {
        UnavoidableFailure.doOrFail {
            try getReturnValue()
        }
    }
}

extension IpcThrowingFunctionResult where T == IpcVoid {
    public func getVoidReturnValueOrFail() {
        UnavoidableFailure.doOrFail {
            try getVoidReturnValue()
        }
    }
}
