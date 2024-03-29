#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCUIAutomation_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>
#import <XCTest/XCUIAccessibilityAuditIssue.h>

@class XCAccessibilityElement, XCUIApplication, XCUIElement;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCUIAccessibilityAuditIssue ()
{
    NSString *_compactDescription;
    NSString *_detailedDescription;
    unsigned long long _auditType;
    XCAccessibilityElement *_axElement;
    XCUIApplication *_application;
}

@property(readonly, nonatomic) XCUIApplication *application; // @synthesize application=_application;
@property(readonly, nonatomic) XCAccessibilityElement *axElement; // @synthesize axElement=_axElement;
- (unsigned long long)_xcuiAuditTypeForXCAXAuditType:(id)arg1;
- (id)description;
- (id)initWithResult:(id)arg1 forApplication:(id)arg2;

@end

#endif