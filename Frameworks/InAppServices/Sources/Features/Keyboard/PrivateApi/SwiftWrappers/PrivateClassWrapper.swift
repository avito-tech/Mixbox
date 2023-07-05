#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation

open class PrivateClassWrapper<T, U> {
    public typealias UnderlyingPrivateApiObject = T
    public typealias UnderlyingPublicApiObject = U
    
    public let underlyingObject: UnderlyingPublicApiObject
    internal let underlyingPrivateApiObject: UnderlyingPrivateApiObject
    
    internal init(
        underlyingPrivateApiObject: UnderlyingPrivateApiObject,
        underlyingPublicApiObject: UnderlyingPublicApiObject
    ) {
        self.underlyingPrivateApiObject = underlyingPrivateApiObject
        self.underlyingObject = underlyingPublicApiObject
    }
    
    public convenience init(underlyingObject: UnderlyingPublicApiObject) throws {
        self.init(
            underlyingPrivateApiObject: try mb_cast(object: underlyingObject),
            underlyingPublicApiObject: underlyingObject
        )
    }
    
    public convenience init(any: Any) throws {
        self.init(
            underlyingPrivateApiObject: try mb_cast(object: any),
            underlyingPublicApiObject: try mb_cast(object: any)
        )
    }
}

#endif
