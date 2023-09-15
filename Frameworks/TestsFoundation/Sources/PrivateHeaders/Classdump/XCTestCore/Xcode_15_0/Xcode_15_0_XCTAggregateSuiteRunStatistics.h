#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTAggregateSuiteRunStatistics : NSObject <NSCopying, NSSecureCoding>
{
    NSString *_lastTestIdentifier;
    NSMutableDictionary *_recordMap;
}

+ (_Bool)supportsSecureCoding;
@property(readonly) NSMutableDictionary *recordMap; // @synthesize recordMap=_recordMap;
@property(copy) NSString *lastTestIdentifier; // @synthesize lastTestIdentifier=_lastTestIdentifier;
- (id)recordForSuiteNamed:(id)arg1;
- (void)addSuiteRecord:(id)arg1;
@property(readonly) NSArray *suiteRecords;
@property(readonly) unsigned long long suiteRecordCount;
@property(readonly) NSDictionary *dictionaryRepresentation;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (_Bool)isEqualToStatistics:(id)arg1;
- (_Bool)isEqual:(id)arg1;
- (id)initWithDictionaryRepresentation:(id)arg1;
- (id)init;

@end

#endif