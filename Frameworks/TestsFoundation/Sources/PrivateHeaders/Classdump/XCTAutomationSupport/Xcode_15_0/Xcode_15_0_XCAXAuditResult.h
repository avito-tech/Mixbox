#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTAutomationSupport_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCAccessibilityElement;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCAXAuditResult : NSObject <NSSecureCoding>
{
    NSString *_compactDescription;
    NSString *_detailedDescription;
    XCAccessibilityElement *_element;
    NSString *_auditType;
}

+ (_Bool)supportsSecureCoding;
@property(copy, nonatomic) NSString *auditType; // @synthesize auditType=_auditType;
@property(copy, nonatomic) XCAccessibilityElement *element; // @synthesize element=_element;
@property(copy, nonatomic) NSString *detailedDescription; // @synthesize detailedDescription=_detailedDescription;
@property(copy, nonatomic) NSString *compactDescription; // @synthesize compactDescription=_compactDescription;
- (id)description;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;

@end

#endif