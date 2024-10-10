#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>
#import <XCTest/XCTAttachment.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTAttachment ()
{
    _Bool _hasPayload;
    NSString *_uniformTypeIdentifier;
    NSString *_name;
    NSDictionary *_userInfo;
    CDUnknownBlockType _serializationBlock;
    long long _internalLifetime;
    NSDate *_timestamp;
    NSString *_fileNameOverride;
    NSData *_payload;
}

+ (id)_attachmentWithUniformTypeIdentifier:(id)arg1 name:(id)arg2 serializationBlock:(CDUnknownBlockType)arg3;

+ (_Bool)supportsSecureCoding;
+ (void)setUserAttachmentLifetime:(long long)arg1;
+ (long long)userAttachmentLifetime;
+ (void)setSystemAttachmentLifetime:(long long)arg1;
+ (long long)systemAttachmentLifetime;

+ (id)_attachmentWithCompressedContentsOfDirectoryAtURL:(id)arg1;

+ (id)_attachmentWithContentsOfFileAtURL:(id)arg1 uniformTypeIdentifier:(id)arg2;

+ (id)_attachmentWithArchivableObject:(id)arg1 uniformTypeIdentifier:(id)arg2;

+ (id)_attachmentWithData:(id)arg1 uniformTypeIdentifier:(id)arg2;
+ (id)attachmentWithXCTImage:(id)arg1;

@property(readonly) _Bool hasPayload; // @synthesize hasPayload=_hasPayload;
@property(readonly, copy) NSData *payload; // @synthesize payload=_payload;
@property(copy) NSString *fileNameOverride; // @synthesize fileNameOverride=_fileNameOverride;
@property(copy) NSDate *timestamp; // @synthesize timestamp=_timestamp;
@property long long internalLifetime; // @synthesize internalLifetime=_internalLifetime;
@property(copy) CDUnknownBlockType serializationBlock; // @synthesize serializationBlock=_serializationBlock;
- (void)copyMetadataFromAttachmentFuture:(id)arg1;
- (id)debugQuickLookObject;
- (void)makeSystem;
- (id)debugDescription;
- (void)_writeToUserInfoWithBlock:(CDUnknownBlockType)arg1;
- (_Bool)isEqual:(id)arg1;
- (unsigned long long)hash;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (void)prepareForEncoding;
- (id)initWithUniformTypeIdentifier:(id)arg1 name:(id)arg2 serializationBlock:(CDUnknownBlockType)arg3;

@end

#endif