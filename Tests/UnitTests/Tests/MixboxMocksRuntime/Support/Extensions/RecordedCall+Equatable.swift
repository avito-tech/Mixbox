import MixboxMocksRuntime

extension RecordedCall: Equatable {
    public static func ==(lhs: RecordedCall, rhs: RecordedCall) -> Bool {
        return lhs.functionIdentifier == rhs.functionIdentifier &&
            lhs.arguments == rhs.arguments
    }
}
