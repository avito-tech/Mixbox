#if defined(MIXBOX_ENABLE_FRAMEWORK_IO_KIT) && defined(MIXBOX_DISABLE_FRAMEWORK_IO_KIT)
#error "IoKit is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IO_KIT) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IO_KIT))
// The compilation is disabled
#else

#ifndef EnumRawValues_h
#define EnumRawValues_h

#if SWIFT_PACKAGE
#include "../PrivateApi/IOKit/hid/IOHIDEventTypes.h"
#else
#include "IOHIDEventTypes.h"
#endif

__BEGIN_DECLS

// Added to support initializing enum with rawValue (enums have only failable initializer, even if they are open).

IOHIDDigitizerTransducerType IOHIDDigitizerTransducerTypeFromRawValue(uint32_t rawValue);
IOHIDEventType IOHIDEventTypeFromRawValue(uint32_t rawValue);

__END_DECLS

#endif /* EnumRawValues_h */
#endif
