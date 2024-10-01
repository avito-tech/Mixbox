#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
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
