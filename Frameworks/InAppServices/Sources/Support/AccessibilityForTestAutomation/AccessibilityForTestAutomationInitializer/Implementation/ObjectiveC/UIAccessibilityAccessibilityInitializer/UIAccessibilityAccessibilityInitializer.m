#if defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES) && defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES)
#error "InAppServices is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES))
// The compilation is disabled
#else

#import "UIAccessibilityAccessibilityInitializer.h"

#import "LoadSimulatorRuntimeLibrary.h"

@interface UIAccessibilityInformationLoader

+ (id)sharedInstance;
- (void)_setNeedsLoadAccessibilityInformationOnMainThread; // just schedules loading (not thread safe)
- (void)_coalesceTimerFired:(id)arg1; // performes scheduled loading
- (void)_loadAccessibilityInformationOnMainThread:(_Bool)arg1; // performs loading (not thread safe)
- (void)setNeedsLoadAccessibilityInformation; // just schedules loading (thread safe; async)
- (void)loadAccessibilityInformation; // performs loading (thread safe; async)

@end

@interface UIAccessibilityAccessibilityInitializer() {
    void *uiAccessibilityHandle;
    NSString *libraryLoadingError;
}

@end

@implementation UIAccessibilityAccessibilityInitializer

// Note: this loads private methods such as `_accessibilityUserTestingChildren`.
// Maybe it does something else, it wasn't thoroughly researched.
- (nullable NSString *)initializeAccessibilityOrReturnError {
    Class UIAccessibilityInformationLoaderClass = NSClassFromString(@"UIAccessibilityInformationLoader");
    BOOL alreadyLoaded = UIAccessibilityInformationLoaderClass != nil;
    BOOL shouldLoad = self->uiAccessibilityHandle == nil;
    
    if (!alreadyLoaded && shouldLoad) {
        NSString *error;
        self->uiAccessibilityHandle = loadSimulatorRuntimeLibrary
        (
         @"/System/Library/PrivateFrameworks/UIAccessibility.framework/UIAccessibility",
         &error
         );
        self->libraryLoadingError = error;
        
        if (!self->uiAccessibilityHandle) {
            return self->libraryLoadingError;
        }
        
        UIAccessibilityInformationLoaderClass = NSClassFromString(@"UIAccessibilityInformationLoader");
        if (!UIAccessibilityInformationLoaderClass) {
            self->libraryLoadingError = @"UIAccessibilityInformationLoader class not found";
            return self->libraryLoadingError;
        }
    } else if (libraryLoadingError != nil) {
        // We shouldn't load library twice, for example.
        // If an error occured, return previous one (without another loading attempt).
        return libraryLoadingError;
    }
    
    if (UIAccessibilityInformationLoaderClass) {
        UIAccessibilityInformationLoader *loader = [UIAccessibilityInformationLoaderClass sharedInstance];
        
        if (!loader) {
            return @"[UIAccessibilityInformationLoaderClass sharedInstance] should not be nil";
        }
        
        // `loadAccessibilityInformation` method can go to background,
        // but we want it to run synchronously, so we will use `_loadAccessibilityInformationOnMainThread`
        //
        // /* @class UIAccessibilityInformationLoader */
        // -(void)loadAccessibilityInformation {
        //     rbx = arg0;
        //     if ([NSThread isMainThread] != 0x0) {
        //             [rbx _loadAccessibilityInformationOnMainThread:0x0];
        //     }
        //     else {
        //             var_30 = *__NSConcreteStackBlock;
        //             *(&var_30 + 0x8) = 0xffffffffc2000000;
        //             *(&var_30 + 0x10) = ___64-[UIAccessibilityInformationLoader loadAccessibilityInformation]_block_invoke;
        //             *(&var_30 + 0x18) = ___block_descriptor_40_e8_32s_e5_v8?0l;
        //             *(&var_30 + 0x20) = rbx;
        //             dispatch_async(*__dispatch_main_q, &var_30);
        //     }
        //     return;
        // }
        
        if ([NSThread isMainThread]) {
            [loader _loadAccessibilityInformationOnMainThread:false];
        } else {
            return [NSString stringWithFormat:@"You should call %@ on main thread", NSStringFromSelector(_cmd)];
        }
    } else {
        // This error is unreachable if the other code is correct.
        return @"Unable to get UIAccessibilityInformationLoader class";
    }
    
    return nil;
}

@end

#endif
