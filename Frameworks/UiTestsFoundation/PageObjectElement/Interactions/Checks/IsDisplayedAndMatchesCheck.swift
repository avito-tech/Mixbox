public final class IsDisplayedAndMatchesCheck: ElementInteraction {
    private let overridenPercentageOfVisibleArea: CGFloat?
    private let buildMatcher: (ElementMatcherBuilder) -> ElementMatcher
    
    public init(
        overridenPercentageOfVisibleArea: CGFloat?,
        buildMatcher: @escaping (ElementMatcherBuilder) -> ElementMatcher)
    {
        self.overridenPercentageOfVisibleArea = overridenPercentageOfVisibleArea
        self.buildMatcher = buildMatcher
    }
    
    public convenience init(
        overridenPercentageOfVisibleArea: CGFloat?,
        matcher: ElementMatcher)
    {
        self.init(
            overridenPercentageOfVisibleArea: overridenPercentageOfVisibleArea,
            buildMatcher: { _ in matcher }
        )
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            overridenPercentageOfVisibleArea: overridenPercentageOfVisibleArea,
            buildMatcher: buildMatcher
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let overridenPercentageOfVisibleArea: CGFloat?
        private let buildMatcher: (ElementMatcherBuilder) -> ElementMatcher
        
        public init(
            dependencies: ElementInteractionDependencies,
            overridenPercentageOfVisibleArea: CGFloat?,
            buildMatcher: @escaping (ElementMatcherBuilder) -> ElementMatcher)
        {
            self.dependencies = dependencies
            self.overridenPercentageOfVisibleArea = overridenPercentageOfVisibleArea
            self.buildMatcher = buildMatcher
        }
        
        public func description() -> String {
            let matcher = buildMatcher(dependencies.elementMatcherBuilder)
            
            return """
                элемент \(dependencies.elementInfo.elementName) матчится матчером "\(matcher.description)"
                """
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return false
        }
        
        public func perform() -> InteractionResult {
            return dependencies.interactionRetrier.retryInteractionUntilTimeout { [buildMatcher, dependencies] _ in
                dependencies.interactionResultMaker.makeResultCatchingErrors {
                    try dependencies.snapshotResolver.resolve(overridenPercentageOfVisibleArea: overridenPercentageOfVisibleArea) { snapshot in
                        let matcher = buildMatcher(dependencies.elementMatcherBuilder)
                        
                        switch matcher.match(value: snapshot) {
                        case .match:
                            return .success
                        case let .mismatch(mismatchResult):
                            return dependencies.interactionResultMaker.failure(
                                message: "проверка неуспешна (\(matcher.description)): \(mismatchResult.mismatchDescription)",
                                attachments: mismatchResult.attachments
                            )
                        }
                    }
                }
            }
        }
    }
}
