#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCTTestIdentifier;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTTestIdentifierSet : NSObject <NSCopying, NSFastEnumeration, NSSecureCoding>
{
}

+ (_Bool)supportsSecureCoding;
+ (id)allocWithZone:(struct _NSZone *)arg1;
+ (id)emptyTestIdentifierSet;
- (Class)classForCoder;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (unsigned long long)countByEnumeratingWithState:(CDStruct_70511ce9 *)arg1 objects:(id *)arg2 count:(unsigned long long)arg3;
- (_Bool)isEqual:(id)arg1;
- (id)description;
- (_Bool)containsTestIdentifier:(id)arg1 includingParents:(_Bool)arg2;
- (_Bool)containsTestIdentifier:(id)arg1;
@property(readonly) unsigned long long count;
- (id)init;
- (id)initWithTestIdentifiers:(const /* was `id *` before dump.py */ void * )arg1 count:(unsigned long long)arg2;
- (id)initWithSet:(id)arg1;
- (id)initWithArray:(id)arg1;
- (id)initWithTestIdentifier:(id)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
@property(readonly) NSDictionary *testIdentifiersGroupedByFirstComponentIdentifier;
- (id)builder;
- (id)setByAddingTestIdentifiersFromSet:(id)arg1;
- (id)setByApplyingBlock:(CDUnknownBlockType)arg1;
- (void)enumerateTestIdentifiersUsingBlock:(CDUnknownBlockType)arg1;
@property(readonly) XCTTestIdentifier *anyTestIdentifier;

@end

#endif