#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <XCTest/XCTDarwinNotificationExpectation.h>
#import <XCTest/XCTestExpectation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTDarwinNotificationExpectation ()
{
    int _notifyToken;
    NSString *_notificationName;
    CDUnknownBlockType _handler;
}

@property int notifyToken; // @synthesize notifyToken=_notifyToken;
- (void)cleanup:(_Bool)arg1;
- (void)_handleNotification;

@end

#endif