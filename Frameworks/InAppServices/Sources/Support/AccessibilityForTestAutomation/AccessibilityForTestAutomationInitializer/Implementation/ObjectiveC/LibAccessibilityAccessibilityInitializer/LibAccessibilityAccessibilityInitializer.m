#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "LibAccessibilityAccessibilityInitializer.h"

#include <dlfcn.h>

@interface LibAccessibilityAccessibilityInitializer() {
    void *libAccessibilityHandle;
    NSString *libraryLoadingError;
    BOOL initialValueWasRead;
}

@end

@implementation LibAccessibilityAccessibilityInitializer

// Copypasted from here: https://github.com/cashapp/AccessibilitySnapshot/blob/master/Sources/AccessibilitySnapshot/Core/ObjC/ASAccessibilityEnabler.m
// And they copypasted it from KIF.
- (nullable NSString *)initializeAccessibilityOrReturnError {
    void *handle = [self loadLibAccessibilityIfNeededAndReturnHandle];
    
    if (!handle) {
        return @"Can't load libAccessibility";
    }

    int (*_AXSAutomationEnabled)(void) = dlsym(handle, "_AXSAutomationEnabled");
    void (*_AXSSetAutomationEnabled)(int) = dlsym(handle, "_AXSSetAutomationEnabled");

    if (!initialValueWasRead) {
        int initialValue = _AXSAutomationEnabled();
        
        // I see no point in this code below, but maybe it's better if I keep it.
        // It was in KIF.
        atexit_b(^{
            _AXSSetAutomationEnabled(initialValue);
        });
        
        initialValueWasRead = YES;
    }
    
    _AXSSetAutomationEnabled(YES);
        
    return nil;
}

- (void *)loadLibAccessibilityIfNeededAndReturnHandle {
    if (self->libAccessibilityHandle) {
        return self->libAccessibilityHandle;
    } else {
        NSDictionary *environment = [[NSProcessInfo processInfo] environment];
        NSString *simulatorRoot = [environment objectForKey:@"IPHONE_SIMULATOR_ROOT"];
        
        NSString *path = @"/usr/lib/libAccessibility.dylib";
        
        if (simulatorRoot) {
            path = [simulatorRoot stringByAppendingPathComponent:path];
        }
        
        self->libAccessibilityHandle = dlopen([path fileSystemRepresentation], RTLD_GLOBAL);
        
        return self->libAccessibilityHandle;
    }
}

@end

#endif
