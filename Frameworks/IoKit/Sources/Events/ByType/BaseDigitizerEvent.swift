#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

#if SWIFT_PACKAGE
import MixboxIoKitObjc
import MixboxFoundationObjc
import MixboxFoundation
#endif

// Types are defined as there:
// https://opensource.apple.com/source/IOHIDFamily/IOHIDFamily-1090.220.12/tools/hidutil/HIDEvent.m.auto.html
public protocol BaseDigitizerEvent: Event {}
extension BaseDigitizerEvent {
    // How to generate:
    //
    // 1. Get constants like `kIOHIDEventFieldDigitizerX,`
    //
    // 2. Replace:
    // kIOHIDEventFieldDigitizer(.)(.*?),
    // =>
    // public var \l$1$2: Bool {
    //     get { return fields.integer[.digitizer$1$2] }
    //     set { fields.integer[.digitizer$1$2] = newValue }
    // }
    //
    // 3. Check types
    //
    public var x: Double {
        get { return fields.float[.digitizerX] }
        set { fields.float[.digitizerX] = newValue }
    }
    public var y: Double {
        get { return fields.float[.digitizerY] }
        set { fields.float[.digitizerY] = newValue }
    }
    public var z: Double {
        get { return fields.float[.digitizerZ] }
        set { fields.float[.digitizerZ] = newValue }
    }
    public var buttonMask: ButtonMask {
        get { return fields.integer[.digitizerButtonMask] }
        set { fields.integer[.digitizerButtonMask] = newValue }
    }
    public var transducer: DigitizerTransducerType {
        get { return fields.integer[.digitizerType] }
        set { fields.integer[.digitizerType] = newValue }
    }
    public var index: UInt32 {
        get { return fields.integer[.digitizerIndex] }
        set { fields.integer[.digitizerIndex] = newValue }
    }
    public var identity: UInt32 {
        get { return fields.integer[.digitizerIdentity] }
        set { fields.integer[.digitizerIdentity] = newValue }
    }
    public var eventMask: DigitizerEventMask {
        get { return fields.integer[.digitizerEventMask] }
        set { fields.integer[.digitizerEventMask] = newValue }
    }
    public var range: Bool {
        get { return fields.integer[.digitizerRange] }
        set { fields.integer[.digitizerRange] = newValue }
    }
    public var touch: Bool {
        get { return fields.integer[.digitizerTouch] }
        set { fields.integer[.digitizerTouch] = newValue }
    }
    public var pressure: Double {
        get { return fields.float[.digitizerPressure] }
        set { fields.float[.digitizerPressure] = newValue }
    }
    public var auxiliaryPressure: Double {
        get { return fields.float[.digitizerAuxiliaryPressure] }
        set { fields.float[.digitizerAuxiliaryPressure] = newValue }
    }
    public var twist: Double {
        get { return fields.float[.digitizerTwist] }
        set { fields.float[.digitizerTwist] = newValue }
    }
    public var tiltX: Double {
        get { return fields.float[.digitizerTiltX] }
        set { fields.float[.digitizerTiltX] = newValue }
    }
    public var tiltY: Double {
        get { return fields.float[.digitizerTiltY] }
        set { fields.float[.digitizerTiltY] = newValue }
    }
    public var altitude: Double {
        get { return fields.float[.digitizerAltitude] }
        set { fields.float[.digitizerAltitude] = newValue }
    }
    public var azimuth: Double {
        get { return fields.float[.digitizerAzimuth] }
        set { fields.float[.digitizerAzimuth] = newValue }
    }
    public var quality: Double {
        get { return fields.float[.digitizerQuality] }
        set { fields.float[.digitizerQuality] = newValue }
    }
    public var density: Double {
        get { return fields.float[.digitizerDensity] }
        set { fields.float[.digitizerDensity] = newValue }
    }
    public var irregularity: Double {
        get { return fields.float[.digitizerIrregularity] }
        set { fields.float[.digitizerIrregularity] = newValue }
    }
    public var majorRadius: Double {
        get { return fields.float[.digitizerMajorRadius] }
        set { fields.float[.digitizerMajorRadius] = newValue }
    }
    public var minorRadius: Double {
        get { return fields.float[.digitizerMinorRadius] }
        set { fields.float[.digitizerMinorRadius] = newValue }
    }
    public var collection: Int32 {
        get { return fields.integer[.digitizerCollection] }
        set { fields.integer[.digitizerCollection] = newValue }
    }
//    public var collectionChord: IDontKnow {
//        get { return fields.integer[.digitizerCollectionChord] }
//        set { fields.integer[.digitizerCollectionChord] = newValue }
//    }
    public var childEventMask: DigitizerEventMask {
        get { return fields.integer[.digitizerChildEventMask] }
        set { fields.integer[.digitizerChildEventMask] = newValue }
    }
    public var isDisplayIntegrated: Bool {
        get { return fields.integer[.digitizerIsDisplayIntegrated] }
        set { fields.integer[.digitizerIsDisplayIntegrated] = newValue }
    }
    public var qualityRadiiAccuracy: Double {
        get { return fields.float[.digitizerQualityRadiiAccuracy] }
        set { fields.float[.digitizerQualityRadiiAccuracy] = newValue }
    }
    public var generationCount: Int32 {
        get { return fields.integer[.digitizerGenerationCount] }
        set { fields.integer[.digitizerGenerationCount] = newValue }
    }
    public var willUpdateMask: UInt32 {
        get { return fields.integer[.digitizerWillUpdateMask] }
        set { fields.integer[.digitizerWillUpdateMask] = newValue }
    }
    public var didUpdateMask: UInt32 {
        get { return fields.integer[.digitizerDidUpdateMask] }
        set { fields.integer[.digitizerDidUpdateMask] = newValue }
    }
}

extension EventIntegerFields {
    public subscript(_ field: IOHIDEventField) -> DigitizerEventMask {
        get {
            return DigitizerEventMask(
                rawValue: UInt32(
                    bitPattern: self[field]
                )
            )
        }
        set {
            self[field] = Int32(
                bitPattern: newValue.rawValue
            )
        }
    }
    
    public subscript(_ field: IOHIDEventField) -> DigitizerTransducerType {
        get {
            return DigitizerTransducerType(
                iohidDigitizerTransducerType: IOHIDDigitizerTransducerTypeFromRawValue(self[field])
            )
        }
        set {
            self[field] = Int32(
                bitPattern: newValue.iohidDigitizerTransducerType.rawValue
            )
        }
    }
}

#endif
