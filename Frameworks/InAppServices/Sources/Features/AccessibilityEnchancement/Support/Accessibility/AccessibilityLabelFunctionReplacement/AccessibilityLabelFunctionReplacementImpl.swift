#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import MixboxIpcCommon
import MixboxFoundation
import MixboxTestability

public final class AccessibilityLabelFunctionReplacementImpl: AccessibilityLabelFunctionReplacement {
    private var thisPointersInStack = [NSObject?]()
    
    private let accessibilityUniqueObjectMap: AccessibilityUniqueObjectMap
    
    public init(accessibilityUniqueObjectMap: AccessibilityUniqueObjectMap) {
        self.accessibilityUniqueObjectMap = accessibilityUniqueObjectMap
    }
    
    public func accessibilityLabel(
        this: NSObject?,
        originalImplementation: () -> NSString?)
        -> NSString?
    {
        // `thisPointersInStack` is introduced to remove any overriding of accessibilty value inside guts
        // of UIKit/UIAccessibility, etc. Only top call to `accessibilityLabel` function will be really overriden.
        //
        // What happens without `thisPointersInStack`?
        //
        // 1. When AX hierarchy is requested this function is called:
        //
        // /* @class UILabelAccessibility */
        // -(void *)accessibilityLabel {
        //     eax = [self _accessibilityLabel:0x1];
        //     return eax;
        // }
        //
        // 2. The this function is called:
        //
        // /* @class UILabelAccessibility */
        // -(void *)_accessibilityLabel:(char)arg2 {
        //     var_12 = arg2;
        //     edi = self;
        //     ebp = ebp;
        //     esi = [[edi accessibilityUserDefinedLabel] retain];
        //     if (esi != 0x0) {
        //             eax = [esi retain];
        //     }
        //     else {
        //             eax = [edi _axOriginalLabelText:sign_extend_32(var_12)];
        //             eax = [eax retain];
        //     }
        //     [esi release];
        //     eax = [eax autorelease];
        //     return eax;
        // }
        //
        // 3. Then `accessibilityUserDefinedLabel` is called.
        // 4. Then implementation of `accessibilityLabel` is called.
        //
        // We should override accessibility label only in top accessibilityLabel function (call #1).
        // For example, if we override accessibility in call #4 then `accessibilityUserDefinedLabel`
        // will return non-nil value and `_axOriginalLabelText` will not be called and then
        // top function (#1, `accessibilityLabel`) will receive enchanced accessibility label WITHOUT
        // text from `_axOriginalLabelText` (for example, string from `text` property of UILabel),
        // so, for example, tests will not receive string from `text` in `label` property of XCElementSnapshot.
        
        return getAccessibilityLabelManagingStack(
            this: this,
            originalImplementation: originalImplementation,
            overridenImplementation: {
                enchancedAccessibilityLabel(
                    this: this,
                    originalImplementation: originalImplementation
                )
            }
        )
    }
    
    private func getAccessibilityLabelManagingStack(
        this: NSObject?,
        originalImplementation: () -> NSString?,
        overridenImplementation: () -> NSString?)
        -> NSString?
    {
        let elementWasAlreadyInStack = thisPointersInStack.contains(where: { $0 === this })
        thisPointersInStack.append(this)
        
        return ObjectiveCExceptionCatcher.catch(
            try: {
                elementWasAlreadyInStack
                    ? originalImplementation()
                    : overridenImplementation()
            },
            catch: { exception in
                exception.raise()
                
                // TODO: Add asserion failure if `raise()` does't produce exception and this code is executed
                
                return nil
            },
            finally: {
                _ = thisPointersInStack.popLast()
            }
        )
    }
    
    private func enchancedAccessibilityLabel(
        this: NSObject?,
        originalImplementation: () -> NSString?)
        -> NSString?
    {
        let unwrappedOriginalAccessibilityLabel = unwrapAccessibilityLabel(
            originalAccessibilityLabel: originalImplementation()
        )
        
        guard let element = this as TestabilityElement? else {
            return unwrappedOriginalAccessibilityLabel
        }
        
        let label = EnhancedAccessibilityLabel(
            originalAccessibilityLabel: unwrappedOriginalAccessibilityLabel as String?,
            accessibilityValue: element.mb_testability_accessibilityValue(),
            uniqueIdentifier: element.mb_testability_uniqueIdentifier(),
            isDefinitelyHidden: element.mb_testability_isDefinitelyHidden(),
            text: element.mb_testability_text(),
            customValues: element.mb_testability_getSerializedCustomValues()
        )
        
        accessibilityUniqueObjectMap.register(element: element)
        
        return (label.toAccessibilityLabel() as NSString?) ?? unwrappedOriginalAccessibilityLabel
    }
    
    // TODO: Eliminate the need of unwrapping the value.
    // This is because calls to accessibilityLabel could be nested, and so label can be wrapped multiple times.
    // I do not know if it is still a case. It was necessary for iOS 9/10, but code was rewritten since then,
    // for example, `thisPointersInStack` was introduced.
    private func unwrapAccessibilityLabel(
        originalAccessibilityLabel: NSString?)
        -> NSString?
    {
        var originalAccessibilityLabel = originalAccessibilityLabel
        
        if originalAccessibilityLabel == nil {
            return nil
        }
        
        while let label = EnhancedAccessibilityLabel.fromAccessibilityLabel(originalAccessibilityLabel as String?) {
            originalAccessibilityLabel = label.originalAccessibilityLabel as NSString?
        }
        
        return originalAccessibilityLabel
    }
}

#endif
