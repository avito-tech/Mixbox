#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class ObjcRuntimeObjcMethodsWithUniqueImplementationProvider:
    ObjcMethodsWithUniqueImplementationProvider
{
    public init() {
    }
    
    public func objcMethodsWithUniqueImplementation(
        baseClass: NSObject.Type,
        selector: Selector,
        methodType: MethodType)
        -> [ObjcMethodWithUniqueImplementation]
    {
        let methodGetter: (AnyClass, Selector) -> Method?
        
        switch methodType {
        case .instanceMethod:
            methodGetter = class_getInstanceMethod
        case .classMethod:
            methodGetter = class_getClassMethod
        }
        
        var classesByMethods = [Method: [AnyClass]]()
        
        var count = UInt32(0)
        guard let classList = objc_copyClassList(&count) else {
            return []
        }
        
        for i in 0..<Int(count) {
            let method = methodGetter(classList[i], selector)
            
            if let method = method {
                let `class`: AnyClass = classList[i]
                if let classes = classesByMethods[method] {
                    classesByMethods[method] = classes + [
                        `class`
                    ]
                } else {
                    classesByMethods[method] = [
                        `class`
                    ]
                }
            }
        }
        
        return classesByMethods
            .compactMap { pair -> ObjcMethodWithUniqueImplementation? in
                pair
                    .value
                    .compactMap {
                        // Make `isSubclass` accessible. Note that it is expected due to `baseClass: NSObject.Type`
                        $0 as? NSObject.Type
                    }
                    .sorted { (lhs: NSObject.Type, rhs: NSObject.Type) -> Bool in
                        // Make base class first in array
                        rhs.isSubclass(of: lhs)
                    }
                    .first
                    .map { `class` in
                        ObjcMethodWithUniqueImplementation(
                            class: `class`,
                            method: pair.key
                        )
                    }
            }
    }
}

#endif
