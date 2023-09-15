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
@interface _XCTTestIdentifier_Array : XCTTestIdentifier
{
    NSArray *_components;
    unsigned long long _options;
}

- (unsigned long long)options;
- (id)components;
- (id)componentAtIndex:(unsigned long long)arg1;
- (unsigned long long)componentCount;
- (id)initWithComponents:(id)arg1 options:(unsigned long long)arg2;

@end

#endif