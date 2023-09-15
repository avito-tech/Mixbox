#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTAutomationSupport_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import "Xcode_15_0_XCTCapabilitiesProviding.h"
#import "Xcode_15_0_XCTRuntimeIssueContextReportingDelegate.h"
#import <Foundation/Foundation.h>

@class XCElementSnapshot;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTElementQueryResults : NSObject <NSSecureCoding, XCTCapabilitiesProviding, XCTRuntimeIssueContextReportingDelegate>
{
    XCElementSnapshot *_rootElement;
    NSOrderedSet *_matchingElements;
    NSSet *_remoteElements;
    NSOrderedSet *_runtimeIssues;
    NSString *_noMatchesMessage;
}

+ (_Bool)supportsSecureCoding;
+ (_Bool)shouldRuntimeIssueContext:(id)arg1 reportIssue:(id)arg2;
+ (void)provideCapabilitiesToBuilder:(id)arg1;
@property(readonly, copy) NSString *noMatchesMessage; // @synthesize noMatchesMessage=_noMatchesMessage;
@property(readonly, copy) NSOrderedSet *runtimeIssues; // @synthesize runtimeIssues=_runtimeIssues;
@property(readonly, copy) NSSet *remoteElements; // @synthesize remoteElements=_remoteElements;
@property(readonly, copy) NSOrderedSet *matchingElements; // @synthesize matchingElements=_matchingElements;
@property(readonly) XCElementSnapshot *rootElement; // @synthesize rootElement=_rootElement;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)resultsByReplacingRuntimeIssues:(id)arg1;
- (id)initWithRootElement:(id)arg1 matchingElements:(id)arg2 remoteElements:(id)arg3 runtimeIssues:(id)arg4 noMatchesMessage:(id)arg5;

// Remaining properties

@end

#endif