#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "AccessibilityOnSimulatorInitializer.h"
#import "AppleInternals.h"

#include <dlfcn.h>
#include <execinfo.h>
#include <objc/runtime.h>
#include <signal.h>

@import UIKit;

@interface AccessibilityOnSimulatorInitializer() {
    void *accessibilityUtilitiesHandle;
    void *libAccessibilityHandle;
}

@end

@implementation AccessibilityOnSimulatorInitializer

// Note: AccessibilityUtilities is a private framework in iOS, it can not be linked during the build.
- (NSString *)setupAccessibilityOrReturnError {
    NSLog(@"Enabling accessibility for automation on Simulator.");
    
    NSTimeInterval pollingTimeout = 60;
    NSTimeInterval pollingInterval = 1;
    NSDate *stopDate = [NSDate dateWithTimeIntervalSinceNow:pollingTimeout];
    
    NSString *error = nil;
    
    SEL selectorThatIsOnlyAvailableIfAxIsSetUp = NSSelectorFromString(@"_accessibilityUserTestingChildren");
    
    while ([stopDate timeIntervalSinceNow] > 0 && ![[UIView new] respondsToSelector:selectorThatIsOnlyAvailableIfAxIsSetUp]) {
        error = [self setupAccessibilityOnceOrReturnError];
        [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:pollingInterval]];
    }
    
    if (![[UIView new] respondsToSelector:selectorThatIsOnlyAvailableIfAxIsSetUp]) {
        NSString *suffix = error
            ? [NSString stringWithFormat:@", nested error: %@", error]
            : @"";
            return [NSString stringWithFormat:@"Failed to enable AX%@", suffix];
    }
    
    return nil;
}

- (NSString *)setupAccessibilityOnceOrReturnError {
    if ([self osMajorVersion] >= 14) {
        return [self setupAccessibilityOnceUsingLibAccessibilityOrReturnError];
    } else {
        return [self setupAccessibilityOnceUsingAccessibilityUtilitiesOrReturnError];
    }
}

// Seems to be working on iOS 14.
// Copypasted from here: https://github.com/cashapp/AccessibilitySnapshot/blob/master/Sources/AccessibilitySnapshot/Core/ObjC/ASAccessibilityEnabler.m
// And they copypasted it from KIF.
- (NSString *)setupAccessibilityOnceUsingLibAccessibilityOrReturnError {
    void *handle = [self loadLibAccessibilityAndReturnHandle];
    
    if (!handle) {
        return @"Can't load libAccessibility";
    }

    int (*_AXSAutomationEnabled)(void) = dlsym(handle, "_AXSAutomationEnabled");
    void (*_AXSSetAutomationEnabled)(int) = dlsym(handle, "_AXSSetAutomationEnabled");

    int initialValue = _AXSAutomationEnabled();
    _AXSSetAutomationEnabled(YES);
    atexit_b(^{
        _AXSSetAutomationEnabled(initialValue);
    });
    
    return nil;
}

- (void *)loadLibAccessibilityAndReturnHandle {
    if (self->libAccessibilityHandle) {
        return self->libAccessibilityHandle;
    } else {
        NSDictionary *environment = [[NSProcessInfo processInfo] environment];
        NSString *simulatorRoot = [environment objectForKey:@"IPHONE_SIMULATOR_ROOT"];
        
        NSString *path = @"/usr/lib/libAccessibility.dylib";
        
        if (simulatorRoot) {
            path = [simulatorRoot stringByAppendingPathComponent:path];
        }
        
        self->libAccessibilityHandle = dlopen([path fileSystemRepresentation], RTLD_LOCAL);
        
        return self->libAccessibilityHandle;
    }
}

// Was working prior to (not including) iOS 14.
// Copypasted from EarlGrey. Became extremely flaky on iOS 14 on Big Sur
// (this, the conditions led to flakiness, is not certain).
- (NSString *)setupAccessibilityOnceUsingAccessibilityUtilitiesOrReturnError {
    [self loadAccessibilityUtilitiesOrReturnError];
    
    Class AXBackBoardServerClass = NSClassFromString(@"AXBackBoardServer");
    if (!AXBackBoardServerClass) {
        return @"AXBackBoardServer class not found";
    }
    
    id server = [AXBackBoardServerClass server];
    if (!server) {
        return @"server should not be nil";
    }
    
    [server setAccessibilityPreferenceAsMobile:(CFStringRef)@"ApplicationAccessibilityEnabled"
                                         value:kCFBooleanTrue
                                  notification:(CFStringRef)@"com.apple.accessibility.cache.app.ax"];
    
    [server setAccessibilityPreferenceAsMobile:(CFStringRef)@"AccessibilityEnabled"
                                         value:kCFBooleanTrue
                                  notification:(CFStringRef)@"com.apple.accessibility.cache.ax"];
    
    return nil;
}

- (NSString *)loadAccessibilityUtilitiesOrReturnError {
    if (self->accessibilityUtilitiesHandle) {
        return nil;
    } else {
        static NSString *path = @"/System/Library/PrivateFrameworks/AccessibilityUtilities.framework/AccessibilityUtilities";
        
        char const *const localPath = [path fileSystemRepresentation];
        if (!localPath) {
            return @"localPath should not be nil";
        }
        
        self->accessibilityUtilitiesHandle = dlopen(localPath, RTLD_LOCAL);
        
        if (self->accessibilityUtilitiesHandle) {
            return nil;
        } else {
            return [NSString stringWithFormat:@"dlopen couldn't open AccessibilityUtilities at path %s", localPath];
        }
    }
}

- (NSInteger)osMajorVersion {
    return [[[[UIDevice.currentDevice systemVersion] componentsSeparatedByString:@"."] firstObject] integerValue];
}

@end

#endif
