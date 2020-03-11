#if MIXBOX_ENABLE_IN_APP_SERVICES

public struct EventOptionBits: OptionSet, Equatable {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public static let isAbsolute = EventOptionBits(rawValue: IOHIDEventOptionBits.isAbsolute.rawValue)
    public static let isCollection = EventOptionBits(rawValue: IOHIDEventOptionBits.isCollection.rawValue)
    public static let isPixelUnits = EventOptionBits(rawValue: IOHIDEventOptionBits.isPixelUnits.rawValue)
    public static let isCenterOrigin = EventOptionBits(rawValue: IOHIDEventOptionBits.isCenterOrigin.rawValue)
    public static let isBuiltIn = EventOptionBits(rawValue: IOHIDEventOptionBits.isBuiltIn.rawValue)
    
    public var iohidEventOptionBits: IOHIDEventOptionBits {
        return IOHIDEventOptionBits(rawValue: rawValue)
    }
}

#endif
