// Not only inverts `isNotDisplayed` check. Also waits element to disappear.
// TODO: Rename?
public final class IsNotDisplayedCheck: ElementInteraction {
    private let maximumAllowedPercentageOfVisibleArea: CGFloat
    
    // Examples:
    // maximumAllowedPercentageOfVisibleArea == 0.01: If less than 1% of view is visible it is considered "not displayed"
    // do not use value `0`, use `CGFloat.leastNonzeroMagnitude`, because visible area can not be less than 0%.
    public init(
        maximumAllowedPercentageOfVisibleArea: CGFloat)
    {
        self.maximumAllowedPercentageOfVisibleArea = maximumAllowedPercentageOfVisibleArea
    }
    
    public convenience init() {
        self.init(maximumAllowedPercentageOfVisibleArea: CGFloat.leastNonzeroMagnitude)
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            maximumAllowedPercentageOfVisibleArea: maximumAllowedPercentageOfVisibleArea
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let maximumAllowedPercentageOfVisibleArea: CGFloat
        
        public init(
            dependencies: ElementInteractionDependencies,
            maximumAllowedPercentageOfVisibleArea: CGFloat)
        {
            self.dependencies = dependencies
            self.maximumAllowedPercentageOfVisibleArea = maximumAllowedPercentageOfVisibleArea
        }
        
        public func description() -> String {
            return """
                "\(dependencies.elementInfo.elementName)" не является видимым
                """
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return false
        }
        
        public func perform() -> InteractionResult {
            return dependencies.interactionRetrier.retryInteractionUntilTimeout { _ in
                // Check if it is displayed to invert result later.
                // This check waits. TODO: Allow to return result immediately.
                let isDisplayedResult = dependencies.interactionPerformer.perform(
                    interaction: IsDisplayedAndMatchesCheck(
                        overridenPercentageOfVisibleArea: maximumAllowedPercentageOfVisibleArea,
                        matcher: AlwaysTrueMatcher<ElementSnapshot>()
                    )
                )
                
                switch isDisplayedResult {
                case .success:
                    return dependencies.interactionResultMaker.failure(message: "является видимым")
                case .failure:
                    return .success
                }
            }
        }
    }
}
