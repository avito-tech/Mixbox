#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class StandardLibraryAssertionFailureRecorder: AssertionFailureRecorder {
    public init() {
    }
    
    public func recordAssertionFailure(
        message: String,
        fileLine: FileLine)
    {
        // TODO: Enable after completing network mocking.
        // assertionFailure(message, file: fileLine.file, line: fileLine.line)
    }
}

#endif
