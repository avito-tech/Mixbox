#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 150000

#import "Xcode_12_0_XCTest_CDStructures.h"
#import "Xcode_12_0_SharedHeader.h"
#import <Foundation/Foundation.h>
#import <XCTest/XCTSourceCodeContext.h>

@class XCTSourceCodeLocation;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTSourceCodeContext ()
{
    NSArray *_callStack;
    XCTSourceCodeLocation *_location;
}

+ (_Bool)supportsSecureCoding;
+ (id)sourceCodeFramesFromCallStackReturnAddresses:(id)arg1;
- (_Bool)isEqual:(id)arg1;
- (unsigned long long)hash;
- (id)initWithCoder:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (id)init;

@end

#endif