import Foundation

public final class RecordedCallsHolderImpl: RecordedCallsHolder {
    private let lock = NSLock()
    private var unsynchronizedRecordedCalls: [RecordedCall] = []
    
    public init() {
    }
    
    @discardableResult
    public func modifyRecordedCalls(
        modify: (inout [RecordedCall]) -> ())
        -> [RecordedCall]
    {
        return lock.lockWhile {
            modify(&unsynchronizedRecordedCalls)
            
            return unsynchronizedRecordedCalls
        }
    }
}
