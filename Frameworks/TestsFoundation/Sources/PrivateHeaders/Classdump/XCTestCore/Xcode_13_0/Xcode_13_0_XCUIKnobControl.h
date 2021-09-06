#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 160000

#import "Xcode_13_0_XCTestCore_CDStructures.h"
#import "Xcode_13_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCUIScreen;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCUIKnobControl : NSObject
{
    XCUIScreen *_screen;
}

@property(readonly) __weak XCUIScreen *screen; // @synthesize screen=_screen;
- (void)select;
- (void)rotateByNumberOfClicks:(unsigned long long)arg1 clockwise:(_Bool)arg2;
- (void)nudgeInDirection:(unsigned long long)arg1;
- (id)initWithScreen:(id)arg1;

@end

#endif