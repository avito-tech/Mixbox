#if MIXBOX_ENABLE_IN_APP_SERVICES

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
