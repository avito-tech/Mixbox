#if defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES) && defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES)
#error "InAppServices is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES))
// The compilation is disabled
#else

@import Foundation;

// Objective C wrapper for private `TIPreferencesController`.
// Objective C is used, because it doesn't require to link TextInput framework
// to use `TIPreferencesController` interface.
@interface TIPreferencesControllerObjCWrapper : NSObject

+ (instancetype)shared;
- (void)setAutocorrectionEnabled:(BOOL)autocorrectionEnabled;
- (void)setPredictionEnabled:(BOOL)predictionEnabled;
- (void)synchronizePreferences;
- (void)setValue:(NSValue *)value forPreferenceKey:(NSString *)key;

@end

#endif
