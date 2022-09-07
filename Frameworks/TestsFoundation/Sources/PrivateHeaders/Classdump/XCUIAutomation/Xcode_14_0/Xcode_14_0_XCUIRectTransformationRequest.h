#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 170000

#import "Xcode_14_0_XCUIAutomation_CDStructures.h"
#import "Xcode_14_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCUITransformParameters;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

__attribute__((visibility("hidden")))
@interface XCUIRectTransformationRequest : NSObject
{
    XCUITransformParameters *_transformParameters;
    struct CGRect _rect;
}

+ (id)rectTransformationRequestWithRect:(struct CGRect)arg1 parameters:(id)arg2;
@property(readonly) XCUITransformParameters *transformParameters; // @synthesize transformParameters=_transformParameters;
@property(readonly) struct CGRect rect; // @synthesize rect=_rect;
@property(readonly) NSArray *axParameterRepresentation;

@end

#endif