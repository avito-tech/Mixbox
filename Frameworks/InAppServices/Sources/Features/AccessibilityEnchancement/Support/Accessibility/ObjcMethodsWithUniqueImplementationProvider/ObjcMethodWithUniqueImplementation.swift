#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation

public final class ObjcMethodWithUniqueImplementation: Hashable, CustomDebugStringConvertible {
    public let `class`: AnyClass
    public let method: Method
    
    public init(
        `class`: AnyClass,
        method: Method)
    {
        self.`class` = `class`
        self.method = method
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: `class`))
        hasher.combine(method)
    }
    
    public static func ==(
        lhs: ObjcMethodWithUniqueImplementation,
        rhs: ObjcMethodWithUniqueImplementation)
        -> Bool
    {
        return lhs.class === rhs.class && lhs.method == rhs.method
    }
    
    public var debugDescription: String {
        return DebugDescriptionBuilder(typeOf: self)
            .add(name: "class", debugDescription: "\(`class`).self")
            .add(name: "method", value: method)
            .debugDescription
    }
}

// For testing (e.g. sorting arrays for comparing actual and expected methods)
extension ObjcMethodWithUniqueImplementation: Comparable {
    public static func <(
        lhs: ObjcMethodWithUniqueImplementation,
        rhs: ObjcMethodWithUniqueImplementation)
        -> Bool
    {
        let lhsAsArray = ["\(lhs.method)", "\(lhs.class)"]
        let rhsAsArray = ["\(rhs.method)", "\(rhs.class)"]
        
        return lhsAsArray.lexicographicallyPrecedes(rhsAsArray)
    }
}

#endif
