#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

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
