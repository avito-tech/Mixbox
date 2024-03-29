#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTAutomationSupport_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCTSignpostEvent;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTSignpostInterval : NSObject <NSCopying, NSSecureCoding>
{
    NSString *_subsystem;
    NSString *_category;
    NSString *_name;
    XCTSignpostEvent *_beginEvent;
    XCTSignpostEvent *_endEvent;
}

+ (_Bool)supportsSecureCoding;
@property(readonly, copy, nonatomic) XCTSignpostEvent *endEvent; // @synthesize endEvent=_endEvent;
@property(readonly, copy, nonatomic) XCTSignpostEvent *beginEvent; // @synthesize beginEvent=_beginEvent;
@property(readonly, copy, nonatomic) NSString *name; // @synthesize name=_name;
@property(readonly, copy, nonatomic) NSString *category; // @synthesize category=_category;
@property(readonly, copy, nonatomic) NSString *subsystem; // @synthesize subsystem=_subsystem;
- (id)description;
- (id)initWithCoder:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (id)initWithSignpostInterval:(id)arg1;
- (id)initWithSubsystem:(id)arg1 category:(id)arg2 name:(id)arg3 beginEvent:(id)arg4 endEvent:(id)arg5;

@end

#endif