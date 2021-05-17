import MixboxMocksRuntime

extension RecordedCallArguments: Equatable {
    public static func ==(lhs: RecordedCallArguments, rhs: RecordedCallArguments) -> Bool {
        return lhs.arguments == rhs.arguments
    }
}
