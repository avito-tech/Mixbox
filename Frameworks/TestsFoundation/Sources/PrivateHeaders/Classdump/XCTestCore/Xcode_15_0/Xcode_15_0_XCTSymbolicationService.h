#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTSymbolicationService : NSObject
{
}

+ (_Bool)isSymbolicationAvailableForSymbolicationFunctions:(CDStruct_37ea9563)arg1 error:(id *)arg2;
+ (CDStruct_37ea9563)standardSymbolicationFunctions;
+ (void)pushSharedSymbolicationService:(id)arg1 forScope:(CDUnknownBlockType)arg2;
+ (void)setSharedService:(id)arg1;
+ (instancetype)sharedService;

@end

#endif