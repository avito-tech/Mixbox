#if MIXBOX_ENABLE_IN_APP_SERVICES

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
