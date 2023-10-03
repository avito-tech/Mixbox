#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCUIAutomation_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCSynthesizedEventRecord : NSObject <NSSecureCoding>
{
    NSMutableArray *_eventPaths;
    _Bool _beginsPersistentState;
    _Bool _endsPersistentState;
    NSString *_name;
    long long _interfaceOrientation;
    long long _targetProcessID;
    unsigned long long _displayID;
    NSDictionary *_systemAutomationProperties;
    struct CGVector _originalOffset;
    struct CGSize _parentWindowSize;
}

+ (_Bool)supportsSecureCoding;
@property struct CGSize parentWindowSize; // @synthesize parentWindowSize=_parentWindowSize;
@property(copy) NSDictionary *systemAutomationProperties; // @synthesize systemAutomationProperties=_systemAutomationProperties;
@property(nonatomic) struct CGVector originalOffset; // @synthesize originalOffset=_originalOffset;
@property _Bool endsPersistentState; // @synthesize endsPersistentState=_endsPersistentState;
@property _Bool beginsPersistentState; // @synthesize beginsPersistentState=_beginsPersistentState;
@property(readonly) unsigned long long displayID; // @synthesize displayID=_displayID;
@property long long targetProcessID; // @synthesize targetProcessID=_targetProcessID;
@property(readonly) long long interfaceOrientation; // @synthesize interfaceOrientation=_interfaceOrientation;
@property(readonly, copy) NSString *name; // @synthesize name=_name;
- (id)description;
@property(readonly) double maximumOffset;
- (void)addPointerEventPath:(id)arg1;
@property(readonly) NSArray *eventPaths;
- (_Bool)isEqual:(id)arg1;
- (unsigned long long)hash;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)initWithName:(id)arg1 interfaceOrientation:(long long)arg2;
- (id)initWithName:(id)arg1 displayID:(unsigned long long)arg2;
- (id)initWithName:(id)arg1;
- (void)unsetInterfaceOrientation;
- (id)initWithName:(id)arg1 displayID:(unsigned long long)arg2 interfaceOrientation:(long long)arg3;
- (_Bool)synthesizeWithError:(id *)arg1;

@end

#endif