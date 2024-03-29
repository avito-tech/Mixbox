#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import "Xcode_15_0_XCTTestIdentifier.h"

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

__attribute__((visibility("hidden")))
@interface _XCTTestIdentifier_Class : XCTTestIdentifier
{
    NSString *_firstComponent;
}

- (id)legacyEncodingCounterpart;
- (id)componentAtIndex:(unsigned long long)arg1;
- (id)lastComponent;
- (id)firstComponent;
- (id)_identifierString;
- (unsigned long long)options;
- (unsigned long long)componentCount;
- (id)components;
- (id)initWithComponents:(id)arg1 options:(unsigned long long)arg2;

@end

#endif