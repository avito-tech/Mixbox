#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpc
import MixboxIpcCommon

final class GetRecordedAssertionFailuresIpcMethodHandler: IpcMethodHandler {
    let method = GetRecordedAssertionFailuresIpcMethod()
    
    private let recordedAssertionFailuresProvider: RecordedAssertionFailuresProvider
    
    init(recordedAssertionFailuresProvider: RecordedAssertionFailuresProvider) {
        self.recordedAssertionFailuresProvider = recordedAssertionFailuresProvider
    }
    
    func handle(
        arguments: GetRecordedAssertionFailuresIpcMethod.Arguments,
        completion: @escaping (GetRecordedAssertionFailuresIpcMethod.ReturnValue) -> ())
    {
        recordedAssertionFailuresProvider.recordedAssertionFailures { recordedAssertionFailures in
            let result: [RecordedAssertionFailure]
            
            if let sinceIndex = arguments.sinceIndex {
                if sinceIndex <= recordedAssertionFailures.count {
                    result = Array(recordedAssertionFailures.suffix(from: sinceIndex))
                } else {
                    result = []
                }
            } else {
                result = recordedAssertionFailures
            }
            
            completion(result)
        }
    }
}

#endif
