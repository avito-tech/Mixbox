#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxIpcCommon

public final class RecordedAssertionFailuresHolder: AssertionFailureRecorder, RecordedAssertionFailuresProvider {
    public private(set) var recordedAssertionFailures = [RecordedAssertionFailure]()
    private let queue = DispatchQueue.global(qos: .userInteractive)
    
    public init() {
    }
    
    public func recordAssertionFailure(
        message: String,
        fileLine: FileLine)
    {
        let date = Date()
        
        queue.async {
            self.recordedAssertionFailures.append(
                RecordedAssertionFailure(
                    date: date,
                    message: message,
                    fileLine: RuntimeFileLine(
                        fileLine: fileLine
                    )
                )
            )
        }
    }
    public func recordedAssertionFailures(completion: @escaping ([RecordedAssertionFailure]) -> ()) {
        queue.async {
            completion(self.recordedAssertionFailures)
        }
    }
}

#endif
