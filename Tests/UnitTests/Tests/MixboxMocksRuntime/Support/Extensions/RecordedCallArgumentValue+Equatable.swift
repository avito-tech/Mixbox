import MixboxMocksRuntime

extension RecordedCallArgumentValue: Equatable {
    public static func ==(lhs: RecordedCallArgumentValue, rhs: RecordedCallArgumentValue) -> Bool {
        switch (lhs, rhs) {
        case (.regular, .regular):
            return true
        case (.escapingClosure, .escapingClosure):
            return true
        case (.optionalEscapingClosure, .optionalEscapingClosure):
            return true
        case (.nonEscapingClosure, .nonEscapingClosure):
            return true
        default:
            return false
        }
    }
}
