#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTAutomationSupport_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTImageConverter : NSObject
{
}

+ (id)_dataForImage:(id)arg1 encoding:(id)arg2 metadata:(id)arg3;
+ (id)dataFromImage:(id)arg1 enforceEncoding:(id)arg2;
+ (id)convertImageIfNecessary:(id)arg1 usingPreferredEncoding:(id)arg2;

@end

#endif