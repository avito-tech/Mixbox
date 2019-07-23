import MixboxIpc
import MixboxBuiltinIpc
import MixboxIpcCommon

// If you want to visualize what happens after calling this method:
//
// (assuming you have IPC between "tests" and "app")
//
//     tests app
//       |    |
//       |o   |          app.call(2)  (app receives [0,1,2])
//       | \  |               |                ^
//       |  \ |               v                |
//       |   o|         tests.call(1)    return [0,1,2]
//       |  / |               |                ^
//       | /  |               v                |
//       |o   |          app.call(0)      return [0,1]
//       | \  |               |                ^
//       |  \ |               |                |
//       |   o|               +-> return [0] --+
//
//  (recursive calls)    (same thing, but in sequence)
//
// So tests call with arguments (2) and expect to receive ([0,1,2]).
// This will check that it is possible to communicate in both directions.
//
public final class BidirectionalIpcPingPongMethod: IpcMethod {
    public final class _Arguments: Codable {
        // <0: invalid values, throws error
        // 0: do not continue calling client
        // 1: call client 1 time
        // etc: etc
        public let countOfCallsLeft: Int
        
        public init(countOfCallsLeft: Int) {
            self.countOfCallsLeft = countOfCallsLeft
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = IpcThrowingFunctionResult<[Int]>
    
    public init() {
    }
}
