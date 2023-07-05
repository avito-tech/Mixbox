#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

// TODO: Log error
internal func handleErrorInTestabilityElementMethod<T>(
    body: () throws -> T,
    defaultValue: () -> T
) -> T {
    do {
        return try body()
    } catch {
        return defaultValue()
    }
}

#endif
