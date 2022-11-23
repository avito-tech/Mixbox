#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public final class CompoundIdlingResource: IdlingResource {
    private let idlingResources: [IdlingResource]
    
    public init(idlingResources: [IdlingResource]) {
        self.idlingResources = idlingResources
    }
    
    public func isIdle() -> Bool {
        return idlingResources.allSatisfy {
            $0.isIdle()
        }
    }
}

#endif
