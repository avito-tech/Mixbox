public final class AndElementInteraction: ElementInteraction {
    private let descriptionBuilder: HumanReadableInteractionDescriptionBuilder
    private let interactions: [ElementInteraction]
    
    public init(
        descriptionBuilder: HumanReadableInteractionDescriptionBuilder,
        interactions: [ElementInteraction])
    {
        self.descriptionBuilder = descriptionBuilder
        self.interactions = interactions
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            descriptionBuilder: descriptionBuilder,
            interactions: interactions
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let descriptionBuilder: HumanReadableInteractionDescriptionBuilder
        private let interactions: [ElementInteraction]
        
        public init(
            dependencies: ElementInteractionDependencies,
            descriptionBuilder: HumanReadableInteractionDescriptionBuilder,
            interactions: [ElementInteraction])
        {
            self.dependencies = dependencies
            self.descriptionBuilder = descriptionBuilder
            self.interactions = interactions
        }
        
        public func description() -> String {
            return descriptionBuilder.description(info: dependencies.elementInfo)
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return interactions.reduce(false) { result, interaction in
                result || interaction.with(dependencies: dependencies).interactionFailureShouldStopTest()
            }
        }
        
        public func perform() -> InteractionResult {
            for interaction in interactions {
                let result = dependencies.interactionPerformer.perform(
                    interaction: interaction
                )
                
                // TODO: result.wasFailed - wrap result?
                if result.wasFailed {
                    return result
                }
            }
            
            return .success
        }
    }
}
