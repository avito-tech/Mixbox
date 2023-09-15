#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import "Xcode_15_0_XCTImageEncoding.h"

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTImageEncoding (XCTImageQuality)
+ (double)compressionQualityForQuality:(long long)arg1;
+ (id)uniformTypeIdentifierForQuality:(long long)arg1;
+ (id)systemScreenshotEncoding;
+ (_Bool)isValidCompressionQuality:(double)arg1 andCompressionQualityObject:(id)arg2;
+ (double)systemScreenshotCompressionQuality;
+ (id)systemScreenshotUniformTypeIdentifier;
- (id)initWithImageQuality:(long long)arg1;
@end

#endif