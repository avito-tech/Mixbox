#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTTestInvocationDescriptor : NSObject
{
    NSString *_selectorString;
    NSNumber *_convention;
    NSInvocation *_invocation;
    NSString *_customErrorMessage;
}

@property(readonly, copy) NSString *customErrorMessage; // @synthesize customErrorMessage=_customErrorMessage;
@property(readonly) NSInvocation *invocation; // @synthesize invocation=_invocation;
@property(readonly) NSNumber *convention; // @synthesize convention=_convention;
@property(readonly, copy) NSString *selectorString; // @synthesize selectorString=_selectorString;
- (id)initWithSelectorString:(id)arg1 convention:(long long)arg2 invocation:(id)arg3 customErrorMessage:(id)arg4;
- (id)initWithSelectorString:(id)arg1 invocation:(id)arg2 customErrorMessage:(id)arg3;
- (id)initWithSelectorString:(id)arg1 conventionNumber:(id)arg2 invocation:(id)arg3 customErrorMessage:(id)arg4;

@end

#endif