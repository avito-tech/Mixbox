#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import MixboxFoundation
import MixboxUiKit

// See: `PredefinedObjcMethodsWithUniqueImplementationProvider`
public final class PredefinedObjcMethodsWithUniqueImplementationBatchesFactoryImpl:
    PredefinedObjcMethodsWithUniqueImplementationBatchesFactory
{
    private let baseClass = NSObject.self
    private let selector = Selector(("_accessibilityAXAttributedLabel"))
    private let methodType = MethodType.instanceMethod
    
    public init() {
    }
    
    public func predefinedObjcMethodsWithUniqueImplementationBatches()
        -> [PredefinedObjcMethodsWithUniqueImplementationBatch]
    {
        return [
            ios11Till12Batch(iosMajorVersion: MixboxIosVersions.Outdated.iOS11.majorVersion),
            ios11Till12Batch(iosMajorVersion: MixboxIosVersions.Outdated.iOS12.majorVersion),
            ios13Batch(),
            ios14Batch(),
            ios15Till16Batch(iosMajorVersion: MixboxIosVersions.Supported.iOS15.majorVersion),
            ios15Till16Batch(iosMajorVersion: MixboxIosVersions.Supported.iOS16.majorVersion)
        ]
    }
    
    private func ios11Till12Batch(iosMajorVersion: Int) -> PredefinedObjcMethodsWithUniqueImplementationBatch {
        return batch(
            iosMajorVersion: iosMajorVersion,
            methods: [
                method(class: "UINavigationBarAccessibility_UIViewAccessibilityAdditions"),
                method(class: "UIAccessibilityTextFieldElement"),
                method(class: "__UINavigationBarAccessibility_UIViewAccessibilityAdditions_super"),
                method(class: "UIView"),
                method(class: "NSObject")
            ]
        )
    }
    
    private func ios13Batch() -> PredefinedObjcMethodsWithUniqueImplementationBatch {
        return batch(
            iosMajorVersion: MixboxIosVersions.Outdated.iOS13.majorVersion,
            methods: [
                method(class: "NSObject"),
                method(class: "UIAccessibilityTextFieldElement"),
                method(class: "UIActivityActionGroupCell"),
                method(class: "UIActivityActionGroupCellAccessibility"),
                method(class: "UINavigationBarAccessibility_UIViewAccessibilityAdditions"),
                method(class: "UIShareGroupActivityCell"),
                method(class: "UIShareGroupActivityCellAccessibility"),
                method(class: "UIView"),
                method(class: "__UIActivityActionGroupCellAccessibility_super"),
                method(class: "__UINavigationBarAccessibility_UIViewAccessibilityAdditions_super"),
                method(class: "__UIShareGroupActivityCellAccessibility_super")
            ]
        )
    }
    
    private func ios14Batch() -> PredefinedObjcMethodsWithUniqueImplementationBatch {
        return batch(
            iosMajorVersion: MixboxIosVersions.Supported.iOS14.majorVersion,
            methods: [
                method(class: "NSObject"),
                method(class: "UIActivityActionGroupCell"),
                method(class: "UIActivityActionGroupCellAccessibility"),
                method(class: "UINavigationBarAccessibility_UIViewAccessibilityAdditions"),
                method(class: "UIShareGroupActivityCell"),
                method(class: "UIShareGroupActivityCellAccessibility"),
                method(class: "UIView"),
                method(class: "__UIActivityActionGroupCellAccessibility_super"),
                method(class: "__UINavigationBarAccessibility_UIViewAccessibilityAdditions_super"),
                method(class: "__UIShareGroupActivityCellAccessibility_super")
            ]
        )
    }
    
    private func ios15Till16Batch(iosMajorVersion: Int) -> PredefinedObjcMethodsWithUniqueImplementationBatch {
        return batch(
            iosMajorVersion: iosMajorVersion,
            methods: [
                method(class: "UINavigationBarAccessibility_UIViewAccessibilityAdditions"),
                method(class: "__UINavigationBarAccessibility_UIViewAccessibilityAdditions_super"),
                method(class: "UIView"),
                method(class: "NSObject"),
                method(class: "UIKeyboardCandidateViewStyle"),
                method(class: "UIKeyboardCandidateViewState"),
                method(class: "_PFPlaceholderMulticaster")
            ]
        )
    }
    
    private func batch(
        iosMajorVersion: Int,
        methods: [PredefinedObjcMethodsWithUniqueImplementationBatch.Method?])
        -> PredefinedObjcMethodsWithUniqueImplementationBatch
    {
        return PredefinedObjcMethodsWithUniqueImplementationBatch(
            iosMajorVersion: iosMajorVersion,
            baseClass: baseClass,
            selector: selector,
            methodsWithUniqueImplementation: methods.compactMap { $0 }
        )
    }
    
    private func method(
        class: String)
        -> PredefinedObjcMethodsWithUniqueImplementationBatch.Method?
    {
        guard let `class` = NSClassFromString(`class`) else {
            return nil
        }
        
        return PredefinedObjcMethodsWithUniqueImplementationBatch.Method(
            class: `class`,
            methodType: methodType
        )
    }
}

#endif
