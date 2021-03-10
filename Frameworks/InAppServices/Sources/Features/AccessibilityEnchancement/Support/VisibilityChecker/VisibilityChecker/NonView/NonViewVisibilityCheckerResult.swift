#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class NonViewVisibilityCheckerResult {
    // `percentageOfVisibleArea` for view with specified `elementUniqueIdentifier`
    public let percentageOfVisibleArea: CGFloat
    
    public init(
        percentageOfVisibleArea: CGFloat)
    {
        self.percentageOfVisibleArea = percentageOfVisibleArea
    }
}

#endif
