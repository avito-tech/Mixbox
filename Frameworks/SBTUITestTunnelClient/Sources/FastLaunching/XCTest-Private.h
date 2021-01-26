#ifndef XCTest_Private_h
#define XCTest_Private_h

#import <XCTest/XCUIApplication.h>

@interface XCUIApplication (Private)
- (id)initPrivateWithPath:(id)arg1 bundleID:(id)arg2;
@end

@interface XCUIElement (Private)
- (void)resolve;
@end

#endif /* XCTest_Private_h */
