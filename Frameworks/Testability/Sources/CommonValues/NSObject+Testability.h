#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

@import UIKit;

#import "TestabilityElementType.h"

@interface NSObject (Testability)

- (BOOL)testabilityValue_hasKeyboardFocus;

- (BOOL)testabilityValue_isEnabled;

- (nonnull NSArray<UIView *> *)testabilityValue_children;

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
// public func testabilityValue_text() -> String?

- (nullable NSString *)testabilityValue_text;

- (TestabilityElementType)testabilityValue_elementType;

@end

#endif
