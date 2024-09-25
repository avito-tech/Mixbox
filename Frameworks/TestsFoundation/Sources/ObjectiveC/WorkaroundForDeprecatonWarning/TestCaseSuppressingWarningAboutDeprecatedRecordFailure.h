@import XCTest;
@import Foundation;

// There is absolutely no way to call `super`'s implemetation
// of recording failure without getting a warning and supporting
// both Xcode 11 and Xcode 12
//
// In Xcode 11 there is a method `recordFailure(...)`:
// - Calling it produces warning in Xcode 12
//
// In Xcode 12 there is a method `record(_: XCTIssue)`:
// - It is not available on Xcode 11
// - Calling super.record(...) calls self.recordFailure(...), not super.recordFailure(...)
//
// The solution is just to suppress warnings as there is no way to fix them.
// Suppressing warnings works only in Objective-C.
@interface TestCaseSuppressingWarningAboutDeprecatedRecordFailure : XCTestCase

- (void)recordFailureBySuperWithDescription:(NSString *)description
                                       file:(NSString *)file
                                       line:(NSUInteger)line
                                   expected:(BOOL)expected
__attribute__((swift_name("recordFailureBySuper(description:file:line:expected:)")));

@end
