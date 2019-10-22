#if MIXBOX_ENABLE_IN_APP_SERVICES

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
