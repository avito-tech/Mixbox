#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation

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
            ios11Till12Batch(iosMajorVersion: 11),
            ios11Till12Batch(iosMajorVersion: 12),
            ios13Batch(),
            ios14Till16Batch(iosMajorVersion: 14),
            ios14Till16Batch(iosMajorVersion: 15),
            ios14Till16Batch(iosMajorVersion: 16)
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
            iosMajorVersion: 13,
            methods: [
                method(class: "UINavigationBarAccessibility_UIViewAccessibilityAdditions"),
                method(class: "UIAccessibilityTextFieldElement"),
                method(class: "NSObject"),
                method(class: "UIShareGroupActivityCellAccessibility"),
                method(class: "UIActivityActionGroupCellAccessibility"),
                method(class: "__UINavigationBarAccessibility_UIViewAccessibilityAdditions_super"),
                method(class: "__UIActivityActionGroupCellAccessibility_super"),
                method(class: "__UIShareGroupActivityCellAccessibility_super"),
                method(class: "UIActivityActionGroupCell"),
                method(class: "UIShareGroupActivityCell"),
                method(class: "UIView")
            ]
        )
    }
    
    private func ios14Till16Batch(iosMajorVersion: Int) -> PredefinedObjcMethodsWithUniqueImplementationBatch {
        return batch(
            iosMajorVersion: iosMajorVersion,
            methods: [
                method(class: "UINavigationBarAccessibility_UIViewAccessibilityAdditions"),
                method(class: "__UINavigationBarAccessibility_UIViewAccessibilityAdditions_super"),
                method(class: "UIView"),
                method(class: "NSObject")
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
