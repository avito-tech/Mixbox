#if defined(MIXBOX_ENABLE_FRAMEWORK_IO_KIT) && defined(MIXBOX_DISABLE_FRAMEWORK_IO_KIT)
#error "IoKit is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IO_KIT) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IO_KIT))
// The compilation is disabled
#else

/*
 *
 * @APPLE_LICENSE_HEADER_START@
 * 
 * Copyright (c) 1999-2003 Apple Computer, Inc.  All Rights Reserved.
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_LICENSE_HEADER_END@
 */

#ifndef _IOKIT_HID_IOHIDEVENTTYPES_H
#define _IOKIT_HID_IOHIDEVENTTYPES_H

#import <Foundation/Foundation.h>

__BEGIN_DECLS

#if SWIFT_PACKAGE
#include "../IOTypes.h"
#else
#include "IOTypes.h"
#endif

#define IOHIDEventTypeMask(type) (1<<type)
#define IOHIDEventFieldBase(type) (type << 16)
/*!
    @typedef IOHIDEventType
    @abstract The type of event represented by an IOHIDEventRef.
    @discussion It is possible that a single IOHIDEventRef can conform to
    multiple event types through the use of sub events.  For futher information
    as to how to determinte the type of event please reference IOHIDEventGetType 
    and IOHIDEventConformsTo.
    @constant kIOHIDEventTypeNULL
    @constant kIOHIDEventTypeVendorDefined
    @constant kIOHIDEventTypeButton
    @constant kIOHIDEventTypeTranslation
    @constant kIOHIDEventTypeRotation
    @constant kIOHIDEventTypeScroll
    @constant kIOHIDEventTypeScale
    @constant kIOHIDEventTypeVelocity
    @constant kIOHIDEventTypeOrientation
    @constant kIOHIDEventTypeKeyboard 
    @constant kIOHIDEventTypeDigitizer
    @constant kIOHIDEventTypeAmbientLightSensor
    @constant kIOHIDEventTypeAccelerometer
    @constant kIOHIDEventTypeProximity
    @constant kIOHIDEventTypeTemperature
    @constant kIOHIDEventTypeMouse
    @constant kIOHIDEventTypeProgress
    @constant kIOHIDEventTypeSwipe
*/
typedef NS_ENUM(uint32_t, IOHIDEventType) {
    kIOHIDEventTypeNULL,
    kIOHIDEventTypeVendorDefined,
    kIOHIDEventTypeButton,
    kIOHIDEventTypeKeyboard, 
    kIOHIDEventTypeTranslation,
    kIOHIDEventTypeRotation,
    kIOHIDEventTypeScroll,
    kIOHIDEventTypeScale,
    kIOHIDEventTypeZoom,
    kIOHIDEventTypeVelocity,
    kIOHIDEventTypeOrientation,
    kIOHIDEventTypeDigitizer,
    kIOHIDEventTypeAmbientLightSensor,
    kIOHIDEventTypeAccelerometer,
    kIOHIDEventTypeProximity,
    kIOHIDEventTypeTemperature,
    kIOHIDEventTypeSwipe,
    kIOHIDEventTypeMouse,
    kIOHIDEventTypeProgress,
    kIOHIDEventTypeCount
};

/*!
	@typedef IOHIDAccelerometerType
	@abstract Type of accelerometer event triggered.
	@constant kIOHIDAccelerometerTypeNormal
	@constant kIOHIDAccelerometerTypeShake
*/
typedef NS_ENUM(uint32_t, IOHIDAccelerometerType) {
    kIOHIDAccelerometerTypeNormal   = 0,
    kIOHIDAccelerometerTypeShake    = 1
};

/*!
	@typedef IOHIDSwipeMask
	@abstract Mask detailing the type of swipe detected.
	@constant kIOHIDProximityDetectionLargeBodyContact
	@constant kIOHIDProximityDetectionLargeBodyFarField
	@constant kIOHIDProximityDetectionIrregularObjects
	@constant kIOHIDProximityDetectionEdgeStraddling
	@constant kIOHIDProximityDetectionFlatFingerClasp
	@constant kIOHIDProximityDetectionFingerTouch
	@constant kIOHIDProximityDetectionReceiver
	@constant kIOHIDProximityDetectionSmallObjectsHovering
    @constant kIOHIDProximityDetectionReceiverCrude
*/
typedef NS_OPTIONS(uint32_t, IOHIDSwipeMask) {
    kIOHIDSwipeUp                             = 0x00000001,
    kIOHIDSwipeDown                           = 0x00000002,
    kIOHIDSwipeLeft                           = 0x00000004,
    kIOHIDSwipeRight                          = 0x00000008,
};


/*!
	@typedef IOHIDProximityDetectionMask
	@abstract Proximity mask detailing the inputs that were detected.
	@constant kIOHIDProximityDetectionLargeBodyContact
	@constant kIOHIDProximityDetectionLargeBodyFarField
	@constant kIOHIDProximityDetectionIrregularObjects
	@constant kIOHIDProximityDetectionEdgeStraddling
	@constant kIOHIDProximityDetectionFlatFingerClasp
	@constant kIOHIDProximityDetectionFingerTouch
	@constant kIOHIDProximityDetectionReceiver
	@constant kIOHIDProximityDetectionSmallObjectsHovering
    @constant kIOHIDProximityDetectionReceiverCrude
*/
typedef NS_OPTIONS(uint32_t, IOHIDProximityDetectionMask) {
    kIOHIDProximityDetectionLargeBodyContact                = 0x0001,
    kIOHIDProximityDetectionLargeBodyFarField               = 0x0002,
    kIOHIDProximityDetectionIrregularObjects                = 0x0004,
    kIOHIDProximityDetectionEdgeStraddling                  = 0x0008,
    kIOHIDProximityDetectionFlatFingerClasp                 = 0x0010,
    kIOHIDProximityDetectionFingerTouch                     = 0x0020,
    kIOHIDProximityDetectionReceiver                        = 0x0040,
    kIOHIDProximityDetectionSmallObjectsHovering            = 0x0080,
    kIOHIDProximityDetectionReceiverCrude                   = 0x0100
};

/*!
	@typedef IOHIDDigitizerType
	@abstract The type of digitizer path initiating an event.
    @discussion The IOHIDDigitizerType usually corresponds to the Logical Collection usage defined in Digitizer Usage Page (0x0d) of the USB HID Usage Tables.
	@constant kIOHIDDigitizerTypeStylus
    @constant kIOHIDDigitizerTypePuck
    @constant kIOHIDDigitizerTypeFinger
*/
typedef NS_ENUM(uint32_t, IOHIDDigitizerTransducerType) {
    kIOHIDDigitizerTransducerTypeStylus = 0,
    kIOHIDDigitizerTransducerTypePuck,
    kIOHIDDigitizerTransducerTypeFinger,
    kIOHIDDigitizerTransducerTypeHand
};

/*!
	@typedef IOHIDDigitizerEventMask
	@abstract Event mask detailing the events being dispatched by a digitizer.
    @discussion It is possible for digitizer events to contain child digitizer events, effectively, behaving as collections.  
    In the collection case, the child event mask field referrence by kIOHIDEventFieldDigitizerChildEventMask will detail the 
    cumulative event state of the child digitizer events.
    <br>
    <b>Please Note:</b>
    If you append a child digitizer event to a parent digitizer event, appropriate state will be transfered on to the parent.
    @constant kIOHIDDigitizerEventRange Issued when the range state has changed.
    @constant kIOHIDDigitizerEventTouch Issued when the touch state has changed.
    @constant kIOHIDDigitizerEventPosition Issued when the position has changed.
    @constant kIOHIDDigitizerEventStop Issued when motion has achieved a state of calculated non-movement.
    @constant kIOHIDDigitizerEventPeak Issues when new maximum values have been detected.
    @constant kIOHIDDigitizerEventIdentity Issued when the identity has changed.
    @constant kIOHIDDigitizerEventAttribute Issued when an attribute has changed.
    @constant kIOHIDDigitizerEventUpSwipe Issued when an up swipe has been detected.
    @constant kIOHIDDigitizerEventDownSwipe Issued when an down swipe has been detected.
    @constant kIOHIDDigitizerEventLeftSwipe Issued when an left swipe has been detected.
    @constant kIOHIDDigitizerEventRightSwipe Issued when an right swipe has been detected.
    @constant kIOHIDDigitizerEventSwipeMask Mask used to gather swipe events.
*/
typedef NS_OPTIONS(uint32_t, IOHIDDigitizerEventMask) {
    kIOHIDDigitizerEventRange                               = 0x00000001,
    kIOHIDDigitizerEventTouch                               = 0x00000002,
    kIOHIDDigitizerEventPosition                            = 0x00000004,
    kIOHIDDigitizerEventStop                                = 0x00000008,
    kIOHIDDigitizerEventPeak                                = 0x00000010,
    kIOHIDDigitizerEventIdentity                            = 0x00000020,
    kIOHIDDigitizerEventAttribute                           = 0x00000040,
    kIOHIDDigitizerEventCancel                              = 0x00000080,
    kIOHIDDigitizerEventStart                               = 0x00000100,
    kIOHIDDigitizerEventResting                             = 0x00000200,
    kIOHIDDigitizerEventSwipeUp                             = 0x01000000,
    kIOHIDDigitizerEventSwipeDown                           = 0x02000000,
    kIOHIDDigitizerEventSwipeLeft                           = 0x04000000,
    kIOHIDDigitizerEventSwipeRight                          = 0x08000000,
    kIOHIDDigitizerEventSwipeMask                           = 0xFF000000,
};

typedef NS_OPTIONS(uint32_t, IOHIDEventOptionBits) {
    kIOHIDEventOptionNone             = 0x00000000, // 0
    kIOHIDEventOptionIsAbsolute       = 0x00000001, // 0x1 << 0
    kIOHIDEventOptionIsCollection     = 0x00000002, // 0x1 << 1
    kIOHIDEventOptionPixelUnits       = 0x00000004, // 0x1 << 2
    kIOHIDEventOptionIsCenterOrigin   = 0x00000008, // 0x1 << 3
    kIOHIDEventOptionIsBuiltIn        = 0x00000010, // 0x1 << 4
    
    // These options are defined in separate unnamed enum in original header,
    // they also clash with other enum:
    kIOHIDEventOptionIgnore           = 0xf0000000, // 0xF << 28
    kIOHIDEventOptionIsRepeat         = 0x00010000, // 0x1 << 10
    kIOHIDEventOptionIsZeroEvent      = 0x00800000, // 0x1 << 4
    
    // Context-dependent (separate enum in original header, but shared in same field):
    kIOHIDKeyboardIsRepeat            = 0x00010000, // 0x1 << 10; Note: deprecated in favor of `kIOHIDEventOptionIsRepeat`
    kIOHIDKeyboardStickyKeyDown       = 0x00020000, // 0x1 << 11
    kIOHIDKeyboardStickyKeyLocked     = 0x00040000, // 0x1 << 12
    kIOHIDKeyboardStickyKeyUp         = 0x00080000, // 0x1 << 13
    kIOHIDKeyboardStickyKeysOn        = 0x00200000, // 0x1 << 15
    kIOHIDKeyboardStickyKeysOff       = 0x00400000, // 0x1 << 16
    
    // Context-dependent (separate enum in original header, but shared in same field):
    kIOHIDTransducerRange             = 0x00010000, // 0x1 << 10
    kIOHIDTransducerTouch             = 0x00020000, // 0x1 << 11
    kIOHIDTransducerInvert            = 0x00040000, // 0x1 << 12
    kIOHIDTransducerDisplayIntegrated = 0x00080000  // 0x1 << 13
};

#ifndef KERNEL
/*!
	@typedef IOHIDFloat
*/
#ifdef __LP64__
typedef double IOHIDFloat;
#else
typedef float IOHIDFloat;
#endif
/*!
	@typedef IOHID3DPoint
*/
typedef struct _IOHID3DPoint {
    IOHIDFloat  x;
    IOHIDFloat  y;
    IOHIDFloat  z;
} IOHID3DPoint; 
#endif

__END_DECLS

#endif /* _IOKIT_HID_IOHIDEVENTTYPES_H */

#endif
