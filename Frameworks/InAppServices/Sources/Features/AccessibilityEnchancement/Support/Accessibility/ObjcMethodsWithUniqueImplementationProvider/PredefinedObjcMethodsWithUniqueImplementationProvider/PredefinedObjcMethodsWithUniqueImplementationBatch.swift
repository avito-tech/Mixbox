#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import MixboxFoundation

public class PredefinedObjcMethodsWithUniqueImplementationBatch {
    public class Method {
        public let `class`: AnyClass
        public let methodType: MethodType
        
        public init(
            class: AnyClass,
            methodType: MethodType)
        {
            self.`class` = `class`
            self.methodType = methodType
        }
    }
    
    // Environment:
    public let iosMajorVersion: Int
    
    // Arguments of `objcMethodsWithUniqueImplementation` of `ObjcMethodsWithUniqueImplementationProvider`
    public let baseClass: AnyClass
    public let selector: Selector
    
    // Resembles return value of that function. Methods (`[Method]`) can be retrieved by calling
    // `class_getInstanceMethod`/`class_getClassMethod` for each selector):
    public let methodsWithUniqueImplementation: [Method]
    
    public init(
        iosMajorVersion: Int,
        baseClass: AnyClass,
        selector: Selector,
        methodsWithUniqueImplementation: [Method])
    {
        self.iosMajorVersion = iosMajorVersion
        self.baseClass = baseClass
        self.selector = selector
        self.methodsWithUniqueImplementation = methodsWithUniqueImplementation
    }
}

#endif
