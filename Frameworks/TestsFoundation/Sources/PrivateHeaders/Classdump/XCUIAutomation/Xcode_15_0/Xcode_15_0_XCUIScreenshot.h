#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCUIAutomation_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>
#import <XCTest/XCUIScreenshot.h>

@class UIImage, XCTImage;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCUIScreenshot ()
{
    XCTImage *_internalImage;
}

+ (id)emptyScreenshot;
@property(retain) XCTImage *internalImage; // @synthesize internalImage=_internalImage;
- (id)debugQuickLookObject;
- (id)initWithImage:(id)arg1;

@end

#endif