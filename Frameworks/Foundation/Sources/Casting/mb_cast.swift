#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public func mb_cast<T, U>(
    object: T,
    sourceType: T.Type = T.self,
    targetType: U.Type = U.self
) throws -> U {
    if let casted = object as? U {
        return casted
    } else {
        throw ErrorString(
            """
            Failed to cast object. \
            Source type: \(T.self). \
            Target type: \(U.self). \
            Actual type: \(type(of: object)). \
            Actual object: \(object)
            """
        )
    }
}
#endif
