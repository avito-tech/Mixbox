#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

import MixboxFoundation
#if SWIFT_PACKAGE
import MixboxIoKitObjc
#endif

public protocol Event: AnyObject {
    var iohidEventRef: IOHIDEventRef { get }
    init(iohidEventRef: IOHIDEventRef)
}

extension Event {
    // NOTE: Prefer using concrete event types, because their properties are type safe
    // (some fields can only be int, some double, etc).
    public var fields: EventFieldsByValueType {
        return EventFieldsByValueType(iohidEventRef: iohidEventRef)
    }

    public var timeStamp: AbsoluteTime {
        get {
            AbsoluteTime(
                darwinAbsoluteTime: IOHIDEventGetTimeStamp(iohidEventRef)
            )
        }
        set {
            IOHIDEventSetTimeStamp(iohidEventRef, newValue.darwinAbsoluteTime)
        }
    }
    
    public var options: EventOptionBits {
        get {
            EventOptionBits(rawValue: IOHIDEventGetEventFlags(iohidEventRef))
        }
        set {
            IOHIDEventSetEventFlags(iohidEventRef, newValue.iohidEventOptionBits.rawValue)
        }
    }
    
    public var type: EventType {
        return EventType(iohidEventType: IOHIDEventGetType(iohidEventRef))
    }
    
    public func append(event: Event, options: IOOptionBits) {
        IOHIDEventAppendEvent(iohidEventRef, event.iohidEventRef, options)
    }
    
    public var children: [Event] {
        guard let pointer = IOHIDEventGetChildren(iohidEventRef) else {
            return []
        }
        let untypedArray = pointer.takeUnretainedValue()
        var typedArray = [IOHIDEventRef]()
        for index in 0..<CFArrayGetCount(untypedArray) {
            if let unsafePointer: UnsafeRawPointer = CFArrayGetValueAtIndex(untypedArray, index) {
                let element = UnsafeMutablePointer(
                    mutating: unsafePointer.assumingMemoryBound(
                        to: __IOHIDEvent.self
                    )
                )
                
                typedArray.append(
                    IOHIDEventCreateCopy(kCFAllocatorDefault, element)
                )
            }
        }
        return typedArray.map { iohidEventRef in
            event(iohidEventRef: iohidEventRef)
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func event(iohidEventRef: IOHIDEventRef) -> Event {
        let eventType = EventType(iohidEventType: IOHIDEventGetType(iohidEventRef))
        switch eventType {
        case .null:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .vendorDefined:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .button:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .keyboard:
            return KeyboardEvent(iohidEventRef: iohidEventRef)
        case .translation:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .rotation:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .scroll:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .scale:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .zoom:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .velocity:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .orientation:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .digitizer:
            let fields = EventIntegerFields(iohidEventRef: iohidEventRef)
            let type: DigitizerTransducerType = fields[.digitizerType]
            
            switch type {
            case .finger:
                return DigitizerFingerEvent(iohidEventRef: iohidEventRef)
            case .hand, .puck, .stylus, .unknown:
                return DigitizerEvent(iohidEventRef: iohidEventRef)
            }
        case .ambientLightSensor:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .accelerometer:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .proximity:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .temperature:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .swipe:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .mouse:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .progress:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .count:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        case .unknown:
            return NotImplementedEvent(iohidEventRef: iohidEventRef)
        }
    }
    
    public var nativeDebugDescription: String {
        NSString(format: "%@", Int(bitPattern: iohidEventRef)) as String
    }
}

private class NotImplementedEvent: Event {
    let iohidEventRef: IOHIDEventRef
    
    required init(iohidEventRef: IOHIDEventRef) {
        self.iohidEventRef = iohidEventRef
    }
}

#endif
