#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "AccessibilityOnSimulatorInitializer.h"
#import "AppleInternals.h"

#include <dlfcn.h>
#include <execinfo.h>
#include <objc/runtime.h>
#include <signal.h>
#import <UIKit/UIKit.h>

@implementation AccessibilityOnSimulatorInitializer

// Note: AccessibilityUtilities is a private framework in iOS, it can not be linked during the build.
- (NSString *)setupAccessibilityOrReturnError {
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
    
    return [self waitUntilAccessibilityIsSetUpOrReturnError];
}

// TODO: Maybe there is a reliable private API for waiting for enabling accessibility.
// Note that it doesn't reproduce in EarlGrey, maybe because there is always a lag
// between enabling AX and using AX APIs.
//
// NOTE: Steps to reproduce the issue with AX not being set:
// - Close simulator
// - Run any Grey Box test
// - See crash
- (NSString *)waitUntilAccessibilityIsSetUpOrReturnError {
    UIView *view = [UIView new];
    NSTimeInterval pollingTimeout = 1;
    NSTimeInterval pollingInterval = 1;
    NSDate *stopDate = [NSDate dateWithTimeIntervalSinceNow:pollingTimeout];
    
    SEL selectorThatIsOnlyAvailableIfAxIsSetUp = NSSelectorFromString(@"_accessibilityUserTestingChildren");
    
    while ([stopDate timeIntervalSinceNow] > 0 && ![view respondsToSelector:selectorThatIsOnlyAvailableIfAxIsSetUp]) {
        [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:pollingInterval]];
    }
    
    if (![view respondsToSelector:selectorThatIsOnlyAvailableIfAxIsSetUp]) {
        return @"Failed to enable AX";
    }
    
    return nil;
}

@end

#endif
