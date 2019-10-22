#if MIXBOX_ENABLE_IN_APP_SERVICES

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
            ios11Till13Batch(iosMajorVersion: 11),
            ios11Till13Batch(iosMajorVersion: 12),
            ios11Till13Batch(iosMajorVersion: 13)
        ]
    }
    
    private func ios11Till13Batch(iosMajorVersion: Int) -> PredefinedObjcMethodsWithUniqueImplementationBatch {
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
