#if MIXBOX_ENABLE_IN_APP_SERVICES

public enum DigitizerTransducerType: Equatable {
    case stylus
    case puck
    case finger
    case hand
    case unknown(UInt32)
    
    public var iohidDigitizerTransducerType: IOHIDDigitizerTransducerType {
        switch self {
        case .stylus:
            return .stylus
        case .puck:
            return .puck
        case .finger:
            return .finger
        case .hand:
            return .hand
        case .unknown(let rawValue):
            return IOHIDDigitizerTransducerTypeFromRawValue(rawValue)
        }
    }
    
    public init(iohidDigitizerTransducerType: IOHIDDigitizerTransducerType) {
        switch iohidDigitizerTransducerType {
        case .stylus:
            self = .stylus
        case .puck:
            self = .puck
        case .finger:
            self = .finger
        case .hand:
            self = .hand
        @unknown default:
            self = .unknown(iohidDigitizerTransducerType.rawValue)
        }
    }
}

#endif
