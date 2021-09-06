#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 160000

#import "Xcode_13_0_XCTestCore_CDStructures.h"
#import "Xcode_13_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCUITransformParameters;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

__attribute__((visibility("hidden")))
@interface XCUIPointTransformationRequest : NSObject
{
    XCUITransformParameters *_transformParameters;
    struct CGPoint _point;
}

+ (id)pointTransformationRequestWithPoint:(struct CGPoint)arg1 parameters:(id)arg2;
@property(readonly) XCUITransformParameters *transformParameters; // @synthesize transformParameters=_transformParameters;
@property(readonly) struct CGPoint point; // @synthesize point=_point;
@property(readonly) NSArray *axParameterRepresentation;

@end

#endif