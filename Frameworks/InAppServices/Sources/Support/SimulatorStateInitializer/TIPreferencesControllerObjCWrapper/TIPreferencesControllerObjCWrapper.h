#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

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
