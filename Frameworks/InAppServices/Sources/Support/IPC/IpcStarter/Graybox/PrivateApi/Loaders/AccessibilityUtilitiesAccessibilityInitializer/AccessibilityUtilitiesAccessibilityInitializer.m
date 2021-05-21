#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "AccessibilityUtilitiesAccessibilityInitializer.h"

#import "LoadSimulatorRuntimeLibrary.h"

@interface AXBackBoardServer

// Returns backboard server instance.
+ (id)server;

// Sets preference with @c key to @c value and raises @c notification.
- (void)setAccessibilityPreferenceAsMobile:(CFStringRef)key
                                     value:(CFBooleanRef)value
                              notification:(CFStringRef)notification;

@end

@interface AccessibilityUtilitiesAccessibilityInitializer() {
    void *accessibilityUtilitiesHandle;
    NSString *libraryLoadingError;
}

@end

@implementation AccessibilityUtilitiesAccessibilityInitializer

// Was working prior to (not including) iOS 14.
// Copypasted from EarlGrey. Became very flaky on iOS 14 on Big Sur
// (this, the conditions led to flakiness, is not certain).
- (NSString *)setupAccessibilityOrReturnError {
    Class AXBackBoardServerClass = NSClassFromString(@"AXBackBoardServer");
    
    BOOL alreadyLoaded = AXBackBoardServerClass != nil;
    BOOL shouldLoad = self->accessibilityUtilitiesHandle == nil;
    
    if (!alreadyLoaded && shouldLoad) {
        [self loadAccessibilityUtilitiesOrReturnError];
        
        AXBackBoardServerClass = NSClassFromString(@"AXBackBoardServer");
        if (!AXBackBoardServerClass) {
            self->libraryLoadingError = @"AXBackBoardServer class not found";
            return self->libraryLoadingError;
        }
    } else if (self->libraryLoadingError) {
        return self->libraryLoadingError;
    }
    
    if (AXBackBoardServerClass) {
        id server = [AXBackBoardServerClass server];
        
        if (!server) {
            return @"[AXBackBoardServerClass server] should not be nil";
        }
        
        [server setAccessibilityPreferenceAsMobile:(CFStringRef)@"ApplicationAccessibilityEnabled"
                                             value:kCFBooleanTrue
                                      notification:(CFStringRef)@"com.apple.accessibility.cache.app.ax"];
        
        [server setAccessibilityPreferenceAsMobile:(CFStringRef)@"AccessibilityEnabled"
                                             value:kCFBooleanTrue
                                      notification:(CFStringRef)@"com.apple.accessibility.cache.ax"];
        
        return nil;
    } else {
        // This error is unreachable if the other code is correct.
        return @"Unable to get AXBackBoardServer class";
    }
}

- (NSString *)loadAccessibilityUtilitiesOrReturnError {
    if (self->accessibilityUtilitiesHandle) {
        return nil;
    } else {
        NSString *error;
        self->accessibilityUtilitiesHandle = loadSimulatorRuntimeLibrary
        (
         @"/System/Library/PrivateFrameworks/AccessibilityUtilities.framework/AccessibilityUtilities",
         &error
         );
        self->libraryLoadingError = error;
        
        if (!self->accessibilityUtilitiesHandle) {
            return self->libraryLoadingError;
        } else {
            return error;
        }
    }
}

@end

#endif
