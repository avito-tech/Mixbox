#import <XCTest/XCTest.h>

@interface XCTestCase (SuppressingWarningAboutDeprecatedRecordFailure)

- (void)recordFailureBySelfWithDescription:(NSString *)description
                                      file:(NSString *)file
                                      line:(NSUInteger)line
                                  expected:(BOOL)expected
__attribute__((swift_name("recordFailureBySelf(description:file:line:expected:)")));

@end
