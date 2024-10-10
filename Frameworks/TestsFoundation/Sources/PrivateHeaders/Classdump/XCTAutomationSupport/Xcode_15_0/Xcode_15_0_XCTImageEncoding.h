#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTAutomationSupport_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTImageEncoding : NSObject <NSSecureCoding>
{
    NSString *_uniformTypeIdentifier;
    double _compressionQuality;
}

+ (_Bool)supportsSecureCoding;
+ (double)maximumCompression;
+ (double)minimumCompression;
@property(readonly, nonatomic) double compressionQuality; // @synthesize compressionQuality=_compressionQuality;
@property(readonly, copy, nonatomic) NSString *uniformTypeIdentifier; // @synthesize uniformTypeIdentifier=_uniformTypeIdentifier;
- (id)dictionaryRepresentation;
- (id)initWithCoder:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (id)description;
- (unsigned long long)hash;
- (_Bool)isEqual:(id)arg1;
- (id)initWithDictionary:(id)arg1;
- (id)initWithUniformTypeIdentifier:(id)arg1 compressionQuality:(double)arg2;

@end

#endif