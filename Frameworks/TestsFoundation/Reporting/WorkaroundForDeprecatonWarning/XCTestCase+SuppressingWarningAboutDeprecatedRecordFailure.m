#import <XCTest/XCTest.h>

@implementation XCTestCase (SuppressingWarningAboutDeprecatedRecordFailure)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)recordFailureBySelfWithDescription:(NSString *)description
                                      file:(NSString *)file
                                      line:(NSUInteger)line
                                  expected:(BOOL)expected
{
    [self recordFailureWithDescription:description
                                inFile:file
                                atLine:line
                              expected:expected];
}

#pragma clang diagnostic pop

@end
