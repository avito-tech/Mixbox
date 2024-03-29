#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 170000

#import "Xcode_14_0_XCUIAutomation_CDStructures.h"
#import "Xcode_14_0_SharedHeader.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCUIInterruptionHandler : NSObject
{
    CDUnknownBlockType _block;
    NSString *_handlerDescription;
    NSUUID *_identifier;
}

@property(readonly, copy) NSUUID *identifier; // @synthesize identifier=_identifier;
@property(readonly, copy) NSString *handlerDescription; // @synthesize handlerDescription=_handlerDescription;
@property(readonly, copy) CDUnknownBlockType block; // @synthesize block=_block;
- (id)initWithBlock:(CDUnknownBlockType)arg1 description:(id)arg2;

@end

#endif