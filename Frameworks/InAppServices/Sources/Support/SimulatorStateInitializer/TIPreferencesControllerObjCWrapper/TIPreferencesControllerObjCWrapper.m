//#if defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES) && defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES)
//#error "InAppServices is marked as both enabled and disabled, choose one of the flags"
//#elif defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES))
//// The compilation is disabled
//#else

#import "TIPreferencesControllerObjCWrapper.h"
#import "TIPreferencesController.h"

@implementation TIPreferencesControllerObjCWrapper {
    TIPreferencesController *tiPreferencesController;
}

+ (instancetype)shared {
    return [
        [self alloc]
        initWithTiPreferencesController: [
            NSClassFromString(@"TIPreferencesController")
            performSelector:@selector(sharedPreferencesController)
        ]
    ];
}

- (instancetype)initWithTiPreferencesController:(TIPreferencesController *)tiPreferencesController {
    if (self = [super init]) {
        self->tiPreferencesController = tiPreferencesController;
    }
    return self;
}

- (void)setAutocorrectionEnabled:(BOOL)autocorrectionEnabled {
    if ([self->tiPreferencesController respondsToSelector:@selector(setAutocorrectionEnabled:)]) {
        self->tiPreferencesController.autocorrectionEnabled = autocorrectionEnabled;
    } else {
        [
            self->tiPreferencesController
            setValue:@(autocorrectionEnabled)
            forPreferenceKey:@"KeyboardAutocorrection"
        ];
    }
}

- (void)setPredictionEnabled:(BOOL)predictionEnabled {
    if ([self->tiPreferencesController respondsToSelector:@selector(setPredictionEnabled:)]) {
        self->tiPreferencesController.predictionEnabled = true;
    } else {
        [
            self->tiPreferencesController
            setValue:@(predictionEnabled)
            forPreferenceKey:@"KeyboardPrediction"
        ];
    }
}

- (void)synchronizePreferences {
    [self->tiPreferencesController synchronizePreferences];
}

- (void)setValue:(NSValue *)value forPreferenceKey:(NSString *)key {
    [self->tiPreferencesController setValue:value forPreferenceKey:key];
}

@end

//#endif
