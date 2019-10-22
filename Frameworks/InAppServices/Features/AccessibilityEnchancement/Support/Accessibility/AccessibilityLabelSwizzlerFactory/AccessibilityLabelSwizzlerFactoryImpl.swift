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
        let enhancedAccessibilityLabelMethodSwizzler = EnhancedAccessibilityLabelMethodSwizzlerImpl()
        let objcRuntimeObjcMethodsWithUniqueImplementationProvider = ObjcRuntimeObjcMethodsWithUniqueImplementationProvider()
        
        let os = iosVersionProvider.iosVersion().majorVersion
        switch os {
        case 9, 10:
            // Unfortunately, we can not swizzle `_accessibilityAXAttributedLabel` on iOS 9 and 10.
            // We must dump all methods of all classes and swizzle ~400 methods.
            // All of it is super slow (1-3 secs).
            return allMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory.allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
                enhancedAccessibilityLabelMethodSwizzler: enhancedAccessibilityLabelMethodSwizzler,
                objcMethodsWithUniqueImplementationProvider: objcRuntimeObjcMethodsWithUniqueImplementationProvider,
                baseClass: NSObject.self,
                selector: #selector(NSObject.accessibilityLabel),
                methodType: .instanceMethod
            )
        case 11, 12, 13:
            // On iOS 11, 12, 13 we can swizzle only few methods. And because those methods are all inside
            // standard Apple libraries we can hardcode them and avoid dumping every method for every class.
            // It is super fast.
            return allMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory.allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
                enhancedAccessibilityLabelMethodSwizzler: enhancedAccessibilityLabelMethodSwizzler,
                objcMethodsWithUniqueImplementationProvider: PredefinedObjcMethodsWithUniqueImplementationProvider(
                    fallbackObjcMethodsWithUniqueImplementationProvider: objcRuntimeObjcMethodsWithUniqueImplementationProvider,
                    predefinedObjcMethodsWithUniqueImplementationBatchesFactory: PredefinedObjcMethodsWithUniqueImplementationBatchesFactoryImpl(),
                    iosVersionProvider: iosVersionProvider
                ),
                baseClass: NSObject.self,
                selector: Selector(("_accessibilityAXAttributedLabel")),
                methodType: .instanceMethod
            )
        default:
            throw ErrorString("Unknown iOS \(os), make sure that accessibilityLabel is swizzled correctly")
        }
    }
}

#endif
