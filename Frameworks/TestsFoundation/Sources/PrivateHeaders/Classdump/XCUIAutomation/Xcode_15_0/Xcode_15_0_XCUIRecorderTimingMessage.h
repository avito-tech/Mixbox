#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCUIAutomation_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

__attribute__((visibility("hidden")))
@interface XCUIRecorderTimingMessage : NSObject
{
    double _start;
    NSString *_message;
}

+ (id)descriptionForTimingMessages:(id)arg1;
+ (id)messageWithString:(id)arg1;
@property(copy) NSString *message; // @synthesize message=_message;
@property double start; // @synthesize start=_start;

@end

#endif