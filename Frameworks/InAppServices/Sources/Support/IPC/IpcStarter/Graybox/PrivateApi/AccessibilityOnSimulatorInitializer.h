#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import <Foundation/Foundation.h>

// This class sets up accessibility for testing, as in XCUI tests.
// So, some accessibility methods and implementations are added to classes and can be used for tests.
// The idea is to make Gray Box tests work as XCUI tests.
//
// Source code was obtained from: https://github.com/google/EarlGrey/blob/87ffa7ac2517cc8931e4e6ba11714961cbac6dd7/EarlGrey/Core/GREYAutomationSetup.m
@interface AccessibilityOnSimulatorInitializer : NSObject

- (nullable NSString *)setupAccessibilityOrReturnError;

@end

#endif
