#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTAutomationSupport_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCTImageEncoding;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTScreenshotRequest : NSObject <NSSecureCoding>
{
    long long _screenID;
    XCTImageEncoding *_encoding;
    unsigned long long _options;
    struct CGRect _rect;
}

+ (_Bool)supportsSecureCoding;
@property(readonly) unsigned long long options; // @synthesize options=_options;
@property(readonly) XCTImageEncoding *encoding; // @synthesize encoding=_encoding;
@property(readonly) struct CGRect rect; // @synthesize rect=_rect;
@property(readonly) long long screenID; // @synthesize screenID=_screenID;
- (id)initWithCoder:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithScreenID:(long long)arg1 rect:(struct CGRect)arg2 encoding:(id)arg3 options:(unsigned long long)arg4;
- (id)initWithScreenID:(long long)arg1 rect:(struct CGRect)arg2 encoding:(id)arg3;

@end

#endif