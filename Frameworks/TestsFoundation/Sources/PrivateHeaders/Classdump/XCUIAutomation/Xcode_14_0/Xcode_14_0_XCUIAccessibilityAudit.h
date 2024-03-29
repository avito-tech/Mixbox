#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 170000

#import "Xcode_14_0_XCUIAutomation_CDStructures.h"
#import "Xcode_14_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCUIApplication;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCUIAccessibilityAudit : NSObject
{
    XCUIApplication *_application;
    NSArray *__auditTypes;
    NSArray *__ignoredIdentifiers;
}

@property(copy, nonatomic) NSArray *_ignoredIdentifiers; // @synthesize _ignoredIdentifiers=__ignoredIdentifiers;
@property(retain, nonatomic) NSArray *_auditTypes; // @synthesize _auditTypes=__auditTypes;
@property(readonly, nonatomic) XCUIApplication *application; // @synthesize application=_application;
- (id)_runAudit:(id *)arg1;
- (id)runAuditWithError:(id *)arg1;
- (id)initWithApplication:(id)arg1 auditType:(id)arg2 elementIdentifiersToIgnore:(id)arg3;

@end

#endif