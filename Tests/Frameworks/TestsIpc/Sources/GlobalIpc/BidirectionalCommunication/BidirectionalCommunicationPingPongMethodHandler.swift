#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation

public final class BidirectionalIpcPingPongMethodHandler: IpcMethodHandler {
    public let method = BidirectionalIpcPingPongMethod()
    
    private let ipcClient: SynchronousIpcClient? // TODO: Not optional (after removing SBTUITestTunnel)
    
    public init(ipcClient: SynchronousIpcClient?) {
        self.ipcClient = ipcClient
    }
    
    // TODO: Replace concrete types with aliases to method types everywhere as here:
    public func handle(
        arguments: BidirectionalIpcPingPongMethod.Arguments,
        completion: @escaping (BidirectionalIpcPingPongMethod.ReturnValue) -> ())
    {
        let result = IpcThrowingFunctionResult {
            try pingPong(countOfCallsLeft: arguments.countOfCallsLeft)
        }
        
        completion(result)
    }
    
    private func pingPong(countOfCallsLeft: Int) throws -> [Int] {
        if countOfCallsLeft > 0 {
            guard let ipcClient = ipcClient else {
                throw ErrorString("ipcClient is nil in BidirectionalIpcPingPongMethodHandler")
            }
            
            let result: BidirectionalIpcPingPongMethod.ReturnValue = try ipcClient.callOrThrow(
                method: BidirectionalIpcPingPongMethod(),
                arguments: BidirectionalIpcPingPongMethod.Arguments(
                    countOfCallsLeft: countOfCallsLeft - 1
                )
            )
            
            return try result.getReturnValue() + [countOfCallsLeft]
        } else if countOfCallsLeft == 0 {
            return [countOfCallsLeft]
        } else {
            throw ErrorString(
                """
                countOfCallsLeft is < 0 (it is \(countOfCallsLeft)), \
                which is an invalid value for \(BidirectionalIpcPingPongMethod.Arguments.self)
                """
            )
        }
    }
}

#endif
