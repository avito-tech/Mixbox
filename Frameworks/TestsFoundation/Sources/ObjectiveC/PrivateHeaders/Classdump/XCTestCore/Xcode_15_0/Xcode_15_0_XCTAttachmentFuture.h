#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <XCTest/XCTAttachment.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTAttachmentFuture : XCTAttachment
{
    NSUUID *_UUID;
    NSUUID *_deviceIdentifier;
}

+ (_Bool)supportsSecureCoding;
@property(readonly, nonatomic) NSUUID *deviceIdentifier; // @synthesize deviceIdentifier=_deviceIdentifier;
@property(readonly, nonatomic) NSUUID *UUID; // @synthesize UUID=_UUID;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithAttachmentFutureMetadata:(id)arg1 name:(id)arg2 deviceIdentifier:(id)arg3;
- (id)initWithCoder:(id)arg1;
- (_Bool)isEqual:(id)arg1;
- (unsigned long long)hash;
- (id)initWithUniformTypeIdentifier:(id)arg1 name:(id)arg2 UUID:(id)arg3 deviceIdentifier:(id)arg4;

@end

#endif