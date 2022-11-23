#if defined(MIXBOX_ENABLE_FRAMEWORK_TESTABILITY) && defined(MIXBOX_DISABLE_FRAMEWORK_TESTABILITY)
#error "Testability is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_TESTABILITY) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_TESTABILITY))
// The compilation is disabled
#else

// This file fixes cocoapods error
//
// <module-includes>:2:9: note: in file included from <module-includes>:2:
// #import "Headers/MixboxTestability-Swift.h"
// ^
// /path/to/DerivedData/.../MixboxTestability.framework/Headers/MixboxTestability-Swift.h:170:9: error: 'MixboxTestability/MixboxTestability.h' file not found
// #import <MixboxTestability/MixboxTestability.h>
// ^
// <unknown>:0: error: could not build Objective-C module 'MixboxTestability'
//

#endif
