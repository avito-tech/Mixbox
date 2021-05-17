import MixboxMocksRuntime

extension RecordedCallArgument: Equatable {
    public static func ==(lhs: RecordedCallArgument, rhs: RecordedCallArgument) -> Bool {
        return lhs.name == rhs.name &&
            lhs.type == rhs.type &&
            lhs.value == rhs.value
    }
}
