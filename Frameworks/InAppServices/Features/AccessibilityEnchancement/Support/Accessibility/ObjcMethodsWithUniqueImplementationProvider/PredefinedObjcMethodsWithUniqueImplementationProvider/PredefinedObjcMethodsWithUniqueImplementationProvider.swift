#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxUiKit

// Getting all methods from all classes in runtime is a costly operation and can take 1-3 seconds.
// For example, if you run 1000 tests on 4 devices it will add 66-200 minutes of workload.
// But for a given iOS version some private Apple APIs can be treated as constants - we can hardcode them.
public final class PredefinedObjcMethodsWithUniqueImplementationProvider:
    ObjcMethodsWithUniqueImplementationProvider
{
    private let fallbackObjcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider
    private let predefinedObjcMethodsWithUniqueImplementationBatchesFactory: PredefinedObjcMethodsWithUniqueImplementationBatchesFactory
    private let getBatchesMapOnceToken = ThreadUnsafeOnceToken<(Map, Int)>()
    private let iosVersionProvider: IosVersionProvider
    
    private final class Key: Hashable {
        let iosMajorVersion: Int
        let baseClassName: String
        let selectorName: String
        
        init(
            iosMajorVersion: Int,
            baseClassName: String,
            selectorName: String)
        {
            self.iosMajorVersion = iosMajorVersion
            self.baseClassName = baseClassName
            self.selectorName = selectorName
        }
        
        convenience init(
            iosMajorVersion: Int,
            baseClass: AnyClass,
            selector: Selector)
        {
            self.init(
                iosMajorVersion: iosMajorVersion,
                baseClassName: "\(baseClass)",
                selectorName: "\(selector)"
            )
        }
        
        static func ==(
            lhs: PredefinedObjcMethodsWithUniqueImplementationProvider.Key,
            rhs: PredefinedObjcMethodsWithUniqueImplementationProvider.Key)
            -> Bool
        {
            return lhs.iosMajorVersion == rhs.iosMajorVersion
                && lhs.baseClassName == rhs.baseClassName
                && lhs.selectorName == rhs.selectorName
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(iosMajorVersion)
            hasher.combine(baseClassName)
            hasher.combine(selectorName)
        }
    }
    
    private typealias Value = [PredefinedObjcMethodsWithUniqueImplementationBatch.Method]
    private typealias Map = [Key: Value]
    
    public init(
        fallbackObjcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider,
        predefinedObjcMethodsWithUniqueImplementationBatchesFactory: PredefinedObjcMethodsWithUniqueImplementationBatchesFactory,
        iosVersionProvider: IosVersionProvider)
    {
        self.fallbackObjcMethodsWithUniqueImplementationProvider = fallbackObjcMethodsWithUniqueImplementationProvider
        self.predefinedObjcMethodsWithUniqueImplementationBatchesFactory = predefinedObjcMethodsWithUniqueImplementationBatchesFactory
        self.iosVersionProvider = iosVersionProvider
    }
    
    public func objcMethodsWithUniqueImplementation(
        baseClass: NSObject.Type,
        selector: Selector,
        methodType: MethodType)
        -> [ObjcMethodWithUniqueImplementation]
    {
        let (map, iosMajorVersion) = getBatchesMapOnceToken.executeOnce {
            (
                predefinedObjcMethodsWithUniqueImplementationBatchesMap(),
                iosVersionProvider.iosVersion().majorVersion
            )
        }
        
        let key = Key(
            iosMajorVersion: iosMajorVersion,
            baseClass: baseClass,
            selector: selector
        )
        
        if let predefinedMethods = map[key] {
            return predefinedMethods.compactMap { predefinedMethod in
                let objcMethod: Method?
                
                if methodType == predefinedMethod.methodType {
                    switch methodType {
                    case .instanceMethod:
                        objcMethod = class_getInstanceMethod(predefinedMethod.`class`, selector)
                    case .classMethod:
                        objcMethod = class_getClassMethod(predefinedMethod.`class`, selector)
                    }
                    
                    return objcMethod.flatMap { objcMethod in
                        ObjcMethodWithUniqueImplementation(
                            class: predefinedMethod.`class`,
                            method: objcMethod
                        )
                    }
                } else {
                    return nil
                }
            }
        } else {
            // Fallback
            
            return fallbackObjcMethodsWithUniqueImplementationProvider.objcMethodsWithUniqueImplementation(
                baseClass: baseClass,
                selector: selector,
                methodType: methodType
            )
        }
    }
    
    private func predefinedObjcMethodsWithUniqueImplementationBatchesMap() -> Map {
        let batches = predefinedObjcMethodsWithUniqueImplementationBatchesFactory.predefinedObjcMethodsWithUniqueImplementationBatches()
        var map = Map()
        
        for batch in batches {
            let key = Key(
                iosMajorVersion: batch.iosMajorVersion,
                baseClass: batch.baseClass,
                selector: batch.selector
            )
            
            map[key] = batch.methodsWithUniqueImplementation
        }
        
        return map
    }
}

#endif
