#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "AccessibilityOnSimulatorInitializer.h"
#import "UIAccessibilityAccessibilityInitializer.h"
#import "LibAccessibilityAccessibilityInitializer.h"
#import "AccessibilityUtilitiesAccessibilityInitializer.h"

@import UIKit;

// In Apple's "UI tests" there is a full support of using accessibility for testing.
// All elements provide their frames, labels, values, etc, correctly.
// Many methods are available at runtime. This class attempts to recreate same
// behavior in unit tests (which is what we use for graybox UI testing).
@interface AccessibilityOnSimulatorInitializer() {
    // Our primary (and the only) method of enabling UI-tests-like accessibility before iOS 14.
    // It became unstable since iOS 14.
    AccessibilityUtilitiesAccessibilityInitializer *accessibilityUtilitiesAccessibilityInitializer;
    
    // A second version, not known to be working reliably either:
    LibAccessibilityAccessibilityInitializer *libAccessibilityAccessibilityInitializer;
    
    // Another way of "doing something" (in order to make AX work, I can't even call it enabling AX).
    // Experiments showed that loading this grants few necessary implementations
    // (i.e. `_accessibilityUserTestingChildren` method), but
    // doesn't really fixes the issue on iOS 14. It can be used as a last resort.
    // I ran tests. In the first test I didn't enable AX at all. In the second test I only
    // used `AccessibilityUtilities` framework. First method gave 0 passed tests. Second gave
    // 56 passed tests (and 140 failed tests nonetheless). All errors I've seen were because
    // elements didn't provide their correct accessibilityFrame.
    UIAccessibilityAccessibilityInitializer *uiAccessibilityAccessibilityInitializer;
}

@end

@implementation AccessibilityOnSimulatorInitializer

- (instancetype)init {
    if (self = [super init]) {
        self->uiAccessibilityAccessibilityInitializer = [UIAccessibilityAccessibilityInitializer new];
        self->libAccessibilityAccessibilityInitializer = [LibAccessibilityAccessibilityInitializer new];
        self->accessibilityUtilitiesAccessibilityInitializer = [AccessibilityUtilitiesAccessibilityInitializer new];
    }
    return self;
}

// NOTE: Steps to reproduce the issue with AX not being set:
// - Comment out code
// - Close simulator
// - Run any Grey Box test
// - See crash
//
// TODO: Maybe there is a reliable private API for waiting for enabling accessibility.
//
- (NSString *)setupAccessibilityOrReturnError {
    NSLog(@"Enabling accessibility for automation on Simulator.");
    
    NSTimeInterval pollingTimeout = 60;
    NSTimeInterval pollingInterval = 1;
    NSDate *stopDate = [NSDate dateWithTimeIntervalSinceNow:pollingTimeout];
    
    NSString *error = nil;
    
    NSString *accessibilityUserTestingChildrenSelectorName = @"_accessibilityUserTestingChildren";
    SEL selectorThatIsOnlyAvailableIfAxIsSetUp = NSSelectorFromString(accessibilityUserTestingChildrenSelectorName);
    
    while ([stopDate timeIntervalSinceNow] > 0 && ![[UIView new] respondsToSelector:selectorThatIsOnlyAvailableIfAxIsSetUp]) {
        error = [self setupAccessibilityOnceOrReturnError];
        [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:pollingInterval]];
    }
    
    if (![[UIView new] respondsToSelector:selectorThatIsOnlyAvailableIfAxIsSetUp]) {
        NSString *fallbackErrorSuffix = @"";
        
        // Last resort (for iOS 14, because it works fine on previous iOS versions without it,
        // and we don't want it to fail silently on previously fine iOS versions):
        if ([self osMajorVersion] >= 14) {
            NSString *fallbackError = [self->uiAccessibilityAccessibilityInitializer setupAccessibilityOrReturnError];
            
            if (!fallbackError) {
                // The `uiAccessibilityAccessibilityInitializer` is expected to cause this selector to appear:
                SEL selectorThatIsOnlyAvailableIfAxIsSetUp = NSSelectorFromString(accessibilityUserTestingChildrenSelectorName);
                
                if (!selectorThatIsOnlyAvailableIfAxIsSetUp) {
                    fallbackError = [NSString stringWithFormat:
                                     @"selector %@ is expected to appear, but it didn't",
                                     accessibilityUserTestingChildrenSelectorName];
                }
            }
            
            if (fallbackError) {
                fallbackErrorSuffix = [NSString stringWithFormat:
                                       @", fallback with UIAccessibility.framework also failed: %@",
                                       fallbackError];
            }
        }
        
        NSString *nestedErrorSuffix = error
            ? [NSString stringWithFormat:
               @", nested error: %@",
               error]
            : @"";
        
        return [NSString stringWithFormat:
                @"Failed to enable AX%@%@",
                nestedErrorSuffix,
                fallbackErrorSuffix];
    }
    
    return nil;
}

- (NSString *)setupAccessibilityOnceOrReturnError {
    NSMutableArray<NSString *> *errors = [NSMutableArray new];
    NSString *error = nil;
    
    // It was never necessary on iOS versions prior to 14, so there's no need to call it,
    // because what it does is really unknown.
    if ([self osMajorVersion] >= 14) {
        if ((error = [self->libAccessibilityAccessibilityInitializer setupAccessibilityOrReturnError])) {
            [errors addObject:error];
        }
    }
    
    if ((error = [self->accessibilityUtilitiesAccessibilityInitializer setupAccessibilityOrReturnError])) {
        [errors addObject:error];
    }
    
    if (errors.count == 1) {
        return errors[0];
    } else {
        return [errors componentsJoinedByString:@", "];
    }
}

- (NSInteger)osMajorVersion {
    return [[[[UIDevice.currentDevice systemVersion] componentsSeparatedByString:@"."] firstObject] integerValue];
}

@end

#endif
