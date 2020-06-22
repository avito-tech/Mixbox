#if MIXBOX_ENABLE_IN_APP_SERVICES
import MixboxIoKit_objc

public struct DigitizerEventMask: OptionSet {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public static let range = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.range.rawValue)
    public static let touch = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.touch.rawValue)
    public static let position = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.position.rawValue)
    public static let stop = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.stop.rawValue)
    public static let peak = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.peak.rawValue)
    public static let identity = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.identity.rawValue)
    public static let attribute = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.attribute.rawValue)
    public static let cancel = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.cancel.rawValue)
    public static let start = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.start.rawValue)
    public static let resting = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.resting.rawValue)
    public static let swipeUp = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.swipeUp.rawValue)
    public static let swipeDown = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.swipeDown.rawValue)
    public static let swipeLeft = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.swipeLeft.rawValue)
    public static let swipeRight = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.swipeRight.rawValue)
    public static let swipeMask = DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.swipeMask.rawValue)
    
    public var iohidDigitizerEventMask: IOHIDDigitizerEventMask {
        return IOHIDDigitizerEventMask(rawValue: rawValue)
    }
}

#endif
