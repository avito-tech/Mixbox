#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

public protocol RecordedAssertionFailuresProvider {
    func recordedAssertionFailures(completion: @escaping ([RecordedAssertionFailure]) -> ())
}

#endif
