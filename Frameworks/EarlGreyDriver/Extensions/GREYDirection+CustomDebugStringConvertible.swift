import EarlGrey

extension GREYDirection: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        case .up:
            return "up"
        case .down:
            return "down"
        }
    }
}
