#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class RecordedAssertionFailure: Codable {
    public let date: Date
    public let message: String
    public let fileLine: RuntimeFileLine
    
    public init(
        date: Date,
        message: String,
        fileLine: RuntimeFileLine)
    {
        self.date = date
        self.message = message
        self.fileLine = fileLine
    }
}

#endif
