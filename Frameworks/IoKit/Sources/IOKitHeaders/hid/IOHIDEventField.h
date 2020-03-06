#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#ifndef IOHIDEventField_h
#define IOHIDEventField_h

// Keys used to set and get individual event fields.
typedef NS_ENUM(uint32_t, IOHIDEventField) {
    // NULL
    kIOHIDEventFieldIsRelative = IOHIDEventFieldBase(kIOHIDEventTypeNULL),
    kIOHIDEventFieldIsCollection,
    kIOHIDEventFieldIsPixelUnits,
    kIOHIDEventFieldIsCenterOrigin,
    kIOHIDEventFieldIsBuiltIn,
    
    // VendorDefined
    kIOHIDEventFieldVendorDefinedUsagePage = IOHIDEventFieldBase(kIOHIDEventTypeVendorDefined),
    kIOHIDEventFieldVendorDefinedUsage,
    kIOHIDEventFieldVendorDefinedVersion,
    kIOHIDEventFieldVendorDefinedDataLength,
    kIOHIDEventFieldVendorDefinedData,

    // Button
    kIOHIDEventFieldButtonMask = IOHIDEventFieldBase(kIOHIDEventTypeButton),
    kIOHIDEventFieldButtonNumber,
    kIOHIDEventFieldButtonClickCount,
    kIOHIDEventFieldButtonPressure,

    // Translation
    kIOHIDEventFieldTranslationX = IOHIDEventFieldBase(kIOHIDEventTypeTranslation),
    kIOHIDEventFieldTranslationY,
    kIOHIDEventFieldTranslationZ,
    
    // Rotation
    kIOHIDEventFieldRotationX = IOHIDEventFieldBase(kIOHIDEventTypeRotation),
    kIOHIDEventFieldRotationY,
    kIOHIDEventFieldRotationZ,
    
    // Scroll
    kIOHIDEventFieldScrollX = IOHIDEventFieldBase(kIOHIDEventTypeScroll),
    kIOHIDEventFieldScrollY,
    kIOHIDEventFieldScrollZ,
    kIOHIDEventFieldScrollIsPixels,
    
    // Scale
    kIOHIDEventFieldScaleX = IOHIDEventFieldBase(kIOHIDEventTypeScale),
    kIOHIDEventFieldScaleY,
    kIOHIDEventFieldScaleZ,
    
    // Velocity
    kIOHIDEventFieldVelocityX = IOHIDEventFieldBase(kIOHIDEventTypeVelocity),
    kIOHIDEventFieldVelocityY,
    kIOHIDEventFieldVelocityZ,
    
    // Accelerometer
    kIOHIDEventFieldAccelerometerX = IOHIDEventFieldBase(kIOHIDEventTypeAccelerometer),
    kIOHIDEventFieldAccelerometerY,
    kIOHIDEventFieldAccelerometerZ,
    kIOHIDEventFieldAccelerometerType,
    
    // Mouse
    kIOHIDEventFieldMouseX = IOHIDEventFieldBase(kIOHIDEventTypeMouse),
    kIOHIDEventFieldMouseY,
    kIOHIDEventFieldMouseZ,
    kIOHIDEventFieldMouseButtonMask,
    kIOHIDEventFieldMouseNumber,
    kIOHIDEventFieldMouseClickCount,
    kIOHIDEventFieldMousePressure,

    // AmbientLightSensor
    kIOHIDEventFieldAmbientLightSensorLevel = IOHIDEventFieldBase(kIOHIDEventTypeAmbientLightSensor),
    kIOHIDEventFieldAmbientLightSensorRawChannel0,
    kIOHIDEventFieldAmbientLightSensorRawChannel1,
    kIOHIDEventFieldAmbientLightDisplayBrightnessChanged,
    
    // Temperature
    kIOHIDEventFieldTemperatureLevel = IOHIDEventFieldBase(kIOHIDEventTypeTemperature),
    
    // Proximity
    kIOHIDEventFieldProximityDetectionMask = IOHIDEventFieldBase(kIOHIDEventTypeProximity),
    
    // Orientation
    kIOHIDEventFieldOrientationRadius   = IOHIDEventFieldBase(kIOHIDEventTypeOrientation),
    kIOHIDEventFieldOrientationAzimuth,
    kIOHIDEventFieldOrientationAltitude,

    // Keyboard
    kIOHIDEventFieldKeyboardUsagePage = IOHIDEventFieldBase(kIOHIDEventTypeKeyboard),
    kIOHIDEventFieldKeyboardUsage,
    kIOHIDEventFieldKeyboardDown,
    kIOHIDEventFieldKeyboardRepeat,
    
    // Digitizer
    kIOHIDEventFieldDigitizerX = IOHIDEventFieldBase(kIOHIDEventTypeDigitizer),
    kIOHIDEventFieldDigitizerY,
    kIOHIDEventFieldDigitizerZ,
    kIOHIDEventFieldDigitizerButtonMask,
    kIOHIDEventFieldDigitizerType,
    kIOHIDEventFieldDigitizerIndex,
    kIOHIDEventFieldDigitizerIdentity,
    kIOHIDEventFieldDigitizerEventMask,
    kIOHIDEventFieldDigitizerRange,
    kIOHIDEventFieldDigitizerTouch,
    kIOHIDEventFieldDigitizerPressure,
    kIOHIDEventFieldDigitizerBarrelPressure,
    kIOHIDEventFieldDigitizerTwist,
    kIOHIDEventFieldDigitizerTiltX,
    kIOHIDEventFieldDigitizerTiltY,
    kIOHIDEventFieldDigitizerAltitude,
    kIOHIDEventFieldDigitizerAzimuth,
    kIOHIDEventFieldDigitizerQuality,
    kIOHIDEventFieldDigitizerDensity,
    kIOHIDEventFieldDigitizerIrregularity,
    kIOHIDEventFieldDigitizerMajorRadius,
    kIOHIDEventFieldDigitizerMinorRadius,
    kIOHIDEventFieldDigitizerCollection,
    kIOHIDEventFieldDigitizerCollectionChord,
    kIOHIDEventFieldDigitizerChildEventMask,
    kIOHIDEventFieldDigitizerIsDisplayIntegrated,

    // Swipe
    kIOHIDEventFieldSwipeMask = IOHIDEventFieldBase(kIOHIDEventTypeSwipe),

    // Progress
    kIOHIDEventFieldProgressEventType = IOHIDEventFieldBase(kIOHIDEventTypeProgress),
    kIOHIDEventFieldProgressLevel
};

#endif /* IOHIDEventField_h */

#endif
