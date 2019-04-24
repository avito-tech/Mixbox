public enum ApplicationState: CustomStringConvertible {
    case unknown
    case notRunning
    case runningBackgroundSuspended
    case runningBackground
    case runningForeground
    
    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .notRunning:
            return "notRunning"
        case .runningBackgroundSuspended:
            return "runningBackgroundSuspended"
        case .runningBackground:
            return "runningBackground"
        case .runningForeground:
            return "runningForeground"
        }
    }
}
