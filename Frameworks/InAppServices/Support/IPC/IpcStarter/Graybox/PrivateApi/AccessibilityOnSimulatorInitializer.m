#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "AccessibilityOnSimulatorInitializer.h"
#import "AppleInternals.h"

#include <dlfcn.h>
#include <execinfo.h>
#include <objc/runtime.h>
#include <signal.h>

@import UIKit;

@implementation AccessibilityOnSimulatorInitializer

// Note: AccessibilityUtilities is a private framework in iOS, it can not be linked during the build.
- (NSString *)setupAccessibilityOrReturnError {
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
    NSLog(@"Enabling accessibility for automation on Simulator.");
    static NSString *path = @"/System/Library/PrivateFrameworks/AccessibilityUtilities.framework/AccessibilityUtilities";
    
    char const *const localPath = [path fileSystemRepresentation];
    if (!localPath) {
        return @"localPath should not be nil";
    }
    
    void *handle = dlopen(localPath, RTLD_LOCAL);
    if (!handle) {
        return [NSString stringWithFormat:@"dlopen couldn't open AccessibilityUtilities at path %s", localPath];
    }
    
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

@end

#endif
