#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// From: https://github.com/google/EarlGrey/blob/87ffa7ac2517cc8931e4e6ba11714961cbac6dd7/EarlGrey/Core/GREYAutomationSetup.m
@interface AccessibilityOnSimulatorInitializer : NSObject

- (nullable NSString *)setupAccessibilityOrReturnError;

@end

NS_ASSUME_NONNULL_END
