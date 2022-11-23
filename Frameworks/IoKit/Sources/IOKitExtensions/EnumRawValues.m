#if defined(MIXBOX_ENABLE_FRAMEWORK_IO_KIT) && defined(MIXBOX_DISABLE_FRAMEWORK_IO_KIT)
#error "IoKit is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IO_KIT) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IO_KIT))
// The compilation is disabled
#else

#include "EnumRawValues.h"

IOHIDDigitizerTransducerType IOHIDDigitizerTransducerTypeFromRawValue(uint32_t rawValue) {
    return (IOHIDDigitizerTransducerType)rawValue;
}

IOHIDEventType IOHIDEventTypeFromRawValue(uint32_t rawValue) {
    return (IOHIDEventType)rawValue;
}

#endif
