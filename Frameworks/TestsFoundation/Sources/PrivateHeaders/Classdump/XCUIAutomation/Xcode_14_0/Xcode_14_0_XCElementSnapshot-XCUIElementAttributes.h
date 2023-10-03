#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 170000

#import "Xcode_14_0_XCUIAutomation_CDStructures.h"
#import "Xcode_14_0_SharedHeader.h"
#import "Xcode_14_0_XCElementSnapshot.h"
#import "Xcode_14_0_XCUIElementSnapshotCoordinateTransforms.h"
#import <XCTest/XCUIElement.h>
#import <XCTest/XCUIElementAttributes.h>
#import <XCTest/XCUIElementTypes.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCElementSnapshot (XCUIElementAttributes) <XCUIElementAttributes, XCUIElementSnapshot, XCUIElementSnapshotCoordinateTransforms>
@property(readonly, copy) NSDictionary *dictionaryRepresentation;
- (id)point:(struct CGPoint)arg1 transformedForEventSynthesisFromOrientation:(long long)arg2 error:(id *)arg3;
- (id)userOrientationTransformedEventSynthesisRect:(struct CGRect)arg1 error:(id *)arg2;
- (id)hostingAndOrientationTransformedRect:(struct CGRect)arg1 error:(id *)arg2;
- (id)_transformRectWithRequest:(id)arg1 error:(id *)arg2;
- (id)hostingAndOrientationTransformedPoint:(struct CGPoint)arg1 error:(id *)arg2;
- (id)_transformPointWithRequest:(id)arg1 error:(id *)arg2;
- (_Bool)_canTransformPoint:(struct CGPoint)arg1;
- (id)_transformParametersOrError:(id *)arg1;
- (id)reparentedOrphanElementMatchingAccessibilityElement:(id)arg1 inconsistentRelationshipDescriptions:(id *)arg2 error:(id *)arg3;
- (id)_snapshotForAccessibilityElement:(id)arg1 error:(id *)arg2;
- (id)snapshotFetchingIfNeededIntoTreeForAccessibilityElement:(id)arg1 error:(id *)arg2;
- (id)hitPointForScrolling:(id *)arg1;
- (id)hitPoint:(id *)arg1;
- (_Bool)_elementIsContainerSubviewWithMatchingFrame:(id)arg1;
- (id)hitTest:(struct CGPoint)arg1;
@property(readonly) NSArray *suggestedHitpoints;

// Remaining properties
@property(readonly) NSArray *children;
@property(readonly) XCUIElementType elementType;
@property(readonly, getter=isEnabled) _Bool enabled;
@property(readonly) struct CGRect frame;
@property(readonly) _Bool hasFocus;
@property(readonly) XCUIUserInterfaceSizeClass horizontalSizeClass;
@property(readonly) NSString *identifier;
@property(readonly, copy) NSString *label;
@property(readonly) NSString *placeholderValue;
@property(readonly, getter=isSelected) _Bool selected;
@property(readonly, copy) NSString *title;
@property(readonly) id value;
@property(readonly) XCUIUserInterfaceSizeClass verticalSizeClass;
@end

#endif