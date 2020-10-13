#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 150000

#import "Xcode_12_0_XCTest_CDStructures.h"
#import "Xcode_12_0_SharedHeader.h"
#import "Xcode_12_0_XCTSwiftErrorObservation_Overlay.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTSwiftErrorObservation : NSObject <XCTSwiftErrorObservation_Overlay>
{
}

+ (id)observeErrorsInBlock:(CDUnknownBlockType)arg1;
+ (void)installSwiftErrorObserverIfPossible;

@end

#endif