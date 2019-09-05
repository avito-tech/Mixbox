public enum TouchActionSpeed {
    case duration(CGFloat)
    case velocity(CGFloat) // In points per second
    
    func duration(pathLength: CGFloat) -> CGFloat {
        switch self {
        case .velocity(let velocity):
            return pathLength / velocity
        case .duration(let duration):
            return duration
        }
    }
    
    func velocity(pathLength: CGFloat) -> CGFloat {
        switch self {
        case .velocity(let velocity):
            return velocity
        case .duration(let duration):
            return pathLength / duration
        }
    }
}
