#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

public enum EventType: Equatable {
    case null
    case vendorDefined
    case button
    case keyboard
    case translation
    case rotation
    case scroll
    case scale
    case zoom
    case velocity
    case orientation
    case digitizer
    case ambientLightSensor
    case accelerometer
    case proximity
    case temperature
    case swipe
    case mouse
    case progress
    case count
    case unknown(UInt32)
    
    public var iohidEventType: IOHIDEventType {
        switch self {
        case .null:
            return .NULL
        case .vendorDefined:
            return .vendorDefined
        case .button:
            return .button
        case .keyboard:
            return .keyboard
        case .translation:
            return .translation
        case .rotation:
            return .rotation
        case .scroll:
            return .scroll
        case .scale:
            return .scale
        case .zoom:
            return .zoom
        case .velocity:
            return .velocity
        case .orientation:
            return .orientation
        case .digitizer:
            return .digitizer
        case .ambientLightSensor:
            return .ambientLightSensor
        case .accelerometer:
            return .accelerometer
        case .proximity:
            return .proximity
        case .temperature:
            return .temperature
        case .swipe:
            return .swipe
        case .mouse:
            return .mouse
        case .progress:
            return .progress
        case .count:
            return .count
        case .unknown(let rawValue):
            return IOHIDEventTypeFromRawValue(rawValue)
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    public init(iohidEventType: IOHIDEventType) {
        switch iohidEventType {
        case .NULL:
            self = .null
        case .vendorDefined:
            self = .vendorDefined
        case .button:
            self = .button
        case .keyboard:
            self = .keyboard
        case .translation:
            self = .translation
        case .rotation:
            self = .rotation
        case .scroll:
            self = .scroll
        case .scale:
            self = .scale
        case .zoom:
            self = .zoom
        case .velocity:
            self = .velocity
        case .orientation:
            self = .orientation
        case .digitizer:
            self = .digitizer
        case .ambientLightSensor:
            self = .ambientLightSensor
        case .accelerometer:
            self = .accelerometer
        case .proximity:
            self = .proximity
        case .temperature:
            self = .temperature
        case .swipe:
            self = .swipe
        case .mouse:
            self = .mouse
        case .progress:
            self = .progress
        case .count:
            self = .count
        @unknown default:
            self = .unknown(iohidEventType.rawValue)
        }
    }
}

#endif
