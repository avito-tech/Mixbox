#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

public struct EventOptionBits: OptionSet, Hashable {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public var iohidEventOptionBits: IOHIDEventOptionBits {
        return IOHIDEventOptionBits(rawValue: rawValue)
    }
    
    public static var isAbsolute: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.eventOptionIsAbsolute.rawValue) }
    public static var isCollection: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.eventOptionIsCollection.rawValue) }
    public static var isPixelUnits: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.eventOptionPixelUnits.rawValue) }
    public static var isCenterOrigin: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.eventOptionIsCenterOrigin.rawValue) }
    public static var isBuiltIn: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.eventOptionIsBuiltIn.rawValue) }
    
    public static var keyboard: KeyboardOptionBits { KeyboardOptionBits() }
    public static var additional: AdditionalOptionBits { AdditionalOptionBits() }
    public static var transducer: TransducerOptionBits { TransducerOptionBits() }

    public final class AdditionalOptionBits {
        public var ignore: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.eventOptionIgnore.rawValue) }
        public var isRepeat: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.eventOptionIsRepeat.rawValue) }
        public var isZeroEvent: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.eventOptionIsZeroEvent.rawValue) }
    }
    
    public final class KeyboardOptionBits {
        public var stickyKeyDown: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.keyboardStickyKeyDown.rawValue) }
        public var stickyKeyLocked: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.keyboardStickyKeyLocked.rawValue) }
        public var stickyKeyUp: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.keyboardStickyKeyUp.rawValue) }
        public var stickyKeysOn: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.keyboardStickyKeysOn.rawValue) }
        public var stickyKeysOff: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.keyboardStickyKeysOff.rawValue) }
    }
    
    public final class TransducerOptionBits {
        public var range: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.transducerRange.rawValue) }
        public var touch: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.transducerTouch.rawValue) }
        public var invert: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.transducerInvert.rawValue) }
        public var displayIntegrated: EventOptionBits { EventOptionBits(rawValue: IOHIDEventOptionBits.transducerDisplayIntegrated.rawValue) }
    }
    
    // Used only for debugDescription
    public enum AssumedOptionBitType: String, Hashable {
        case general
        case keyboard
        case transducer
        case unknown
    }
    
    public var debugDescription: String {
        debugDescription(assumedOptionBitType: .unknown)
    }
    
    public func debugDescription(assumedOptionBitType: AssumedOptionBitType) -> String {
        EventOptionBitsDebugDescriptionProvider.debugDescription(
            eventOptionBits: self,
            assumedOptionBitType: assumedOptionBitType
        )
    }
}

private final class EventOptionBitsDebugDescriptionProvider {
    static func debugDescription(
        eventOptionBits: EventOptionBits,
        assumedOptionBitType: EventOptionBits.AssumedOptionBitType
    ) -> String {
        let (relevantNamesByBits, irrelevantNamesByBits) = namesByBitsByRelevance(
            assumedOptionBitType: assumedOptionBitType
        )
        
        var remainingBits = eventOptionBits.rawValue
        
        var components = self.components(
            namesByBits: relevantNamesByBits,
            remainingBits: &remainingBits
        )
        
        if remainingBits != 0 {
            let bitsBeforeFindingIrrelevantComponents = remainingBits
            
            let irrelevantComponents = self.components(
                namesByBits: irrelevantNamesByBits,
                remainingBits: &remainingBits
            )
            
            let component = "unknown option bits (\(bitsBeforeFindingIrrelevantComponents.hexString))"
            
            if irrelevantComponents.isEmpty {
                components.append(component)
            } else {
                components.append("\(component), found bits irrelevant for given assumedOptionBitType (\(assumedOptionBitType)): \(irrelevantComponents.joined(separator: " & "))")
            }
        }
        
        return "(EventOptionBits: \(components.joined(separator: " & ")))"
    }
    
    private static func namesByBitsByRelevance(
        assumedOptionBitType: EventOptionBits.AssumedOptionBitType
    ) -> (
        relevantNamesByBits: [EventOptionBits: [String]],
        irrelevantNamesByBits: [EventOptionBits: [String]]
    ) {
        let namesByBitsByType = self.namesByBitsByType
        
        var relevantNamesByBits: [EventOptionBits: [String]] = [:]
        var irrelevantNamesByBits: [EventOptionBits: [String]] = [:]
        
        relevantNamesByBits.addValues(namesByBitsByType[.general])
        
        switch assumedOptionBitType {
        case .general:
            irrelevantNamesByBits.addValues(namesByBitsByType[.keyboard])
            irrelevantNamesByBits.addValues(namesByBitsByType[.transducer])
        case .keyboard:
            relevantNamesByBits.addValues(namesByBitsByType[.keyboard])
            irrelevantNamesByBits.addValues(namesByBitsByType[.transducer])
        case .transducer:
            relevantNamesByBits.addValues(namesByBitsByType[.transducer])
            irrelevantNamesByBits.addValues(namesByBitsByType[.keyboard])
        case .unknown:
            relevantNamesByBits.addValues(namesByBitsByType[.keyboard])
            relevantNamesByBits.addValues(namesByBitsByType[.transducer])
        }
        
        return (
            relevantNamesByBits: relevantNamesByBits,
            irrelevantNamesByBits: irrelevantNamesByBits
        )
    }
    
    private static var namesByBitsByType: [EventOptionBits.AssumedOptionBitType: [EventOptionBits: String]] {
        [
            .general: [
                .isAbsolute: "isAbsolute",
                .isCollection: "isCollection",
                .isPixelUnits: "isPixelUnits",
                .isCenterOrigin: "isCenterOrigin",
                .isBuiltIn: "isBuiltIn",
                .additional.ignore: "additional.ignore",
                .additional.isRepeat: "additional.isRepeat",
                .additional.isZeroEvent: "additional.isZeroEvent"
            ],
            .keyboard: [
                .keyboard.stickyKeyDown: "keyboard.stickyKeyDown",
                .keyboard.stickyKeyLocked: "keyboard.stickyKeyLocked",
                .keyboard.stickyKeyUp: "keyboard.stickyKeyUp",
                .keyboard.stickyKeysOn: "keyboard.stickyKeysOn",
                .keyboard.stickyKeysOff: "keyboard.stickyKeysOff"
            ],
            .transducer: [
                .transducer.range: "transducer.range",
                .transducer.touch: "transducer.touch",
                .transducer.invert: "transducer.invert",
                .transducer.displayIntegrated: "transducer.displayIntegrated"
            ]
        ]
    }
    
    private static func components(
        namesByBits: [EventOptionBits: [String]],
        remainingBits: inout UInt32
    ) -> [String] {
        var components = [String]()
        
        for (bits, names) in namesByBits.sorted(by: { lhs, rhs in lhs.key.rawValue < rhs.key.rawValue }) {
            if !names.isEmpty && remainingBits & bits.rawValue == bits.rawValue {
                remainingBits = remainingBits & ~(remainingBits & bits.rawValue)
                
                components.append("\(names.joined(separator: " or ")) (\(bits.rawValue.hexString))")
            }
        }
        
        return components
    }
}

private extension UInt32 {
    var hexString: String {
        "0x\(String(self, radix: 16))"
    }
}

private extension Dictionary {
    mutating func addValues<T>(_ other: [Key: T]?) where Value == [T] {
        guard let other = other else { return }
        
        for (key, value) in other {
            self[key, default: []].append(value)
        }
    }
}

#endif
