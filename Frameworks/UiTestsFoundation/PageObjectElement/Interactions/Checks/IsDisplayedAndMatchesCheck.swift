public final class IsDisplayedAndMatchesCheck: ElementInteraction {
    private let minimalPercentageOfVisibleArea: CGFloat
    private let buildMatcher: (ElementMatcherBuilder) -> ElementMatcher
    
    public init(
        minimalPercentageOfVisibleArea: CGFloat,
        buildMatcher: @escaping (ElementMatcherBuilder) -> ElementMatcher)
    {
        self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
        self.buildMatcher = buildMatcher
    }
    
    public convenience init(
        minimalPercentageOfVisibleArea: CGFloat,
        matcher: ElementMatcher)
    {
        self.init(
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            buildMatcher: { _ in matcher }
        )
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            buildMatcher: buildMatcher
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let minimalPercentageOfVisibleArea: CGFloat
        private let buildMatcher: (ElementMatcherBuilder) -> ElementMatcher
        
        public init(
            dependencies: ElementInteractionDependencies,
            minimalPercentageOfVisibleArea: CGFloat,
            buildMatcher: @escaping (ElementMatcherBuilder) -> ElementMatcher)
        {
            self.dependencies = dependencies
            self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
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
                dependencies.snapshotResolver.resolve(minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea) { snapshot in
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
