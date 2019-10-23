#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxUiKit

public class AccessibilityLabelSwizzlerFactoryImpl: AccessibilityLabelSwizzlerFactory {
    private let allMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory: AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory
    private let iosVersionProvider: IosVersionProvider
    
    public init(
        allMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory: AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory,
        iosVersionProvider: IosVersionProvider)
    {
        self.allMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory = allMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory
        self.iosVersionProvider = iosVersionProvider
    }
    
    public func accessibilityLabelSwizzler() throws -> AccessibilityLabelSwizzler {
        let accessibilityLabelFunctionReplacement = AccessibilityLabelFunctionReplacementImpl()
        let objcRuntimeObjcMethodsWithUniqueImplementationProvider = ObjcRuntimeObjcMethodsWithUniqueImplementationProvider()
        
        let predefinedObjcMethodsWithUniqueImplementationProvider = PredefinedObjcMethodsWithUniqueImplementationProvider(
            fallbackObjcMethodsWithUniqueImplementationProvider: objcRuntimeObjcMethodsWithUniqueImplementationProvider,
            predefinedObjcMethodsWithUniqueImplementationBatchesFactory: PredefinedObjcMethodsWithUniqueImplementationBatchesFactoryImpl(),
            iosVersionProvider: iosVersionProvider
        )
        
        let os = iosVersionProvider.iosVersion().majorVersion
        switch os {
        case 10:
            return ios10AccessibilityLabelSwizzler(
                accessibilityLabelFunctionReplacement: accessibilityLabelFunctionReplacement,
                objcRuntimeObjcMethodsWithUniqueImplementationProvider: objcRuntimeObjcMethodsWithUniqueImplementationProvider,
                predefinedObjcMethodsWithUniqueImplementationProvider: predefinedObjcMethodsWithUniqueImplementationProvider
            )
        case 11, 12, 13:
            return ios11OrHigherAccessibilityLabelSwizzler(
                accessibilityLabelFunctionReplacement: accessibilityLabelFunctionReplacement,
                objcRuntimeObjcMethodsWithUniqueImplementationProvider: objcRuntimeObjcMethodsWithUniqueImplementationProvider,
                predefinedObjcMethodsWithUniqueImplementationProvider: predefinedObjcMethodsWithUniqueImplementationProvider
            )
        default:
            throw ErrorString("Unknown iOS \(os), make sure that accessibilityLabel is swizzled correctly")
        }
    }
    
    private func ios10AccessibilityLabelSwizzler(
        accessibilityLabelFunctionReplacement: AccessibilityLabelFunctionReplacement,
        objcRuntimeObjcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider,
        predefinedObjcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider)
        -> AccessibilityLabelSwizzler
    {
        // Unfortunately, we can not swizzle `_accessibilityAXAttributedLabel` on iOS 9 and 10.
        // We must dump all methods of all classes and swizzle ~400 methods.
        // All of it is super slow (1-3 secs).
        return allMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory.allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
            enhancedAccessibilityLabelMethodSwizzler: EnhancedAccessibilityLabelMethodSwizzlerImpl(
                accessibilityLabelFunctionReplacement: accessibilityLabelFunctionReplacement
            ),
            objcMethodsWithUniqueImplementationProvider: objcRuntimeObjcMethodsWithUniqueImplementationProvider,
            baseClass: NSObject.self,
            selector: #selector(NSObject.accessibilityLabel),
            methodType: .instanceMethod
        )
    }
    
    private func ios11OrHigherAccessibilityLabelSwizzler(
        accessibilityLabelFunctionReplacement: AccessibilityLabelFunctionReplacement,
        objcRuntimeObjcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider,
        predefinedObjcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider)
        -> AccessibilityLabelSwizzler
    {
        // On iOS 11, 12, 13 we can swizzle only few methods. And because those methods are all inside
        // standard Apple libraries we can hardcode them and avoid dumping every method for every class.
        // It is super fast.
        return allMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory.allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
            enhancedAccessibilityLabelMethodSwizzler: EnhancedAccessibilityLabelMethodSwizzlerImpl(
                accessibilityLabelFunctionReplacement: accessibilityLabelFunctionReplacement
            ),
            objcMethodsWithUniqueImplementationProvider: predefinedObjcMethodsWithUniqueImplementationProvider,
            baseClass: NSObject.self,
            selector: Selector(("_accessibilityAXAttributedLabel")),
            methodType: .instanceMethod
        )
    }
}

#endif
