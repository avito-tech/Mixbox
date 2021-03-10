#import "TestCaseSuppressingWarningAboutDeprecatedRecordFailure.h"

@implementation TestCaseSuppressingWarningAboutDeprecatedRecordFailure

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)recordFailureBySuperWithDescription:(NSString *)description
                                       file:(NSString *)file
                                       line:(NSUInteger)line
                                   expected:(BOOL)expected
{
    [super recordFailureWithDescription:description
                                 inFile:file
                                 atLine:line
                               expected:expected];
    
}

#pragma clang diagnostic pop

@end
