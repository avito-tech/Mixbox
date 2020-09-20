@import UIKit;

#import "TestabilityElementType.h"

// NOTE: `customValues` is purely a Swift feature.
@protocol TestabilityElement

- (CGRect)mb_testability_frame;

// Note that there is no way to calculate this from fields, because the logic of coordinates conversion
// is not constant for every view (and is proprietary for many views).
- (CGRect)mb_testability_frameRelativeToScreen;

- (nonnull NSString *)mb_testability_customClass;

- (TestabilityElementType)mb_testability_elementType;

- (nullable NSString *)mb_testability_accessibilityIdentifier;

- (nullable NSString *)mb_testability_accessibilityLabel;

- (nullable NSString *)mb_testability_accessibilityValue;

- (nullable NSString *)mb_testability_accessibilityPlaceholderValue;

// Return nil if the concept of text is not applicable to the view (e.g.: UIImageView).
// Return visible text, you may not care about the font/color/overlapping.
// E.g. if there is a `placeholder` and `text` properties and view is configured to display placeholder,
// return `placeholder` property, if it is configured to display text, return `text`.
// If it not configured to display text, return "" (not nil, because text is applicable for the view if it might
// contain text).
// Note that there is no alternative to this in XCUI. XCUI contain "value" and "label" and:
// 1. none of these are text
// 2. you don't know for sure what to check (and thus you can not check for inequality of text, because
//    most of the time some property will be not equal to some text, and the problem is more serious with regexes)
//
//    E.g. value = "ABC", label = "", visible text is "ABC"

//    Equality is simple. You can check both value and label and if one matches then the assertion was successful.
//
//    assert(value == "ABC" || label == "ABC")
//
//    But you should not use || with negative assertions and regexes.
//
//    let regex = "^[^A-Z]*$" (has no letters)
//    assert(value.matches(regex) || label.matches(regex)) // will succeed, because label "" has no letters.
//
//    So in order to test text properly you have to have a single source of information.
//
// 3. there are some cases where `label` and `value` seems to be a text (for UIButton). Example:
//    - There is a UIButton
//    - It has text "X" for state `normal`
//    - It has text "" for `selected` (or `disabled`)
//    - It is in the state `selected` (or `disabled`)
//    - What user sees on the screen: "" (because it is the text for the current state)
//    - What XCUI sees in accessibility label: "X"
//
// TODO: enum instead of optional string?
// case notApplicapable
// case text(String)
//
// NOTE: Swift signature:
// public func mb_testability_text() -> String?

- (nullable NSString *)mb_testability_text;

// Unique identifier of the element. Can be used to request info about the element,
// for example, percentage of visible area of the view, etc.
- (nonnull NSString *)mb_testability_uniqueIdentifier;

// true: is hidden, can not be visible even after scrolling.
// false: we don't know
//
// TODO: Rename/refactor.
// The name should make the reasons to use the function obvious.
// And SRP seems to be violated.
//
// There are multiple reasons to use this property (1 & 2 are quite same though):
// 1. Fast check if view is hidden before performing an expensive check.
// 2. Ignore temporary cells in collection view that are used for animations.
// 3. Check if we can scroll to the element and then perform check for visibility.
//    E.g.: isDefinitelyHidden == true => we should not even try to scroll
//          isDefinitelyHidden == false => we should consider scrolling to the view.
//
- (BOOL)mb_testability_isDefinitelyHidden;

- (BOOL)mb_testability_isEnabled;

- (BOOL)mb_testability_hasKeyboardFocus;

- (nullable id<TestabilityElement>)mb_testability_parent;

- (nonnull NSArray<id<TestabilityElement>> *)mb_testability_children;

@end
