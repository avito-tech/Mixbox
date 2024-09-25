#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

#if SWIFT_PACKAGE
import MixboxIoKitObjc
#endif

public struct DigitizerEventMask: OptionSet {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public static var range: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.range.rawValue) }
    public static var touch: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.touch.rawValue) }
    public static var position: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.position.rawValue) }
    public static var stop: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.stop.rawValue) }
    public static var peak: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.peak.rawValue) }
    public static var identity: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.identity.rawValue) }
    public static var attribute: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.attribute.rawValue) }
    public static var cancel: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.cancel.rawValue) }
    public static var start: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.start.rawValue) }
    public static var resting: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.resting.rawValue) }
    public static var swipeUp: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.swipeUp.rawValue) }
    public static var swipeDown: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.swipeDown.rawValue) }
    public static var swipeLeft: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.swipeLeft.rawValue) }
    public static var swipeRight: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.swipeRight.rawValue) }
    public static var swipeMask: DigitizerEventMask { DigitizerEventMask(rawValue: IOHIDDigitizerEventMask.swipeMask.rawValue) }
    
    public var iohidDigitizerEventMask: IOHIDDigitizerEventMask {
        return IOHIDDigitizerEventMask(rawValue: rawValue)
    }
}

#endif
