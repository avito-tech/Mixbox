#if defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES) && defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES)
#error "InAppServices is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES))
// The compilation is disabled
#else

@import Foundation;

/**
 * Text Input preferences controller to modify the keyboard preferences for iOS 8+.
 */
@interface TIPreferencesController : NSObject

/** Whether the autocorrection is enabled. */
@property BOOL autocorrectionEnabled;

/** Whether the predication is enabled. */
@property BOOL predictionEnabled;

/** The shared singleton instance. */
+ (instancetype)sharedPreferencesController;

/** Synchronize the change to save it on disk. */
- (void)synchronizePreferences;

/** Modify the preference @c value by @c key. */
- (void)setValue:(NSValue *)value forPreferenceKey:(NSString *)key;

@end

#endif
