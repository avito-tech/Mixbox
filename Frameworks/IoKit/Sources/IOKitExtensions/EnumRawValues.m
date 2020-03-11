#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#include "EnumRawValues.h"

IOHIDDigitizerTransducerType IOHIDDigitizerTransducerTypeFromRawValue(uint32_t rawValue) {
    return (IOHIDDigitizerTransducerType)rawValue;
}

IOHIDEventType IOHIDEventTypeFromRawValue(uint32_t rawValue) {
    return (IOHIDEventType)rawValue;
}

#endif
