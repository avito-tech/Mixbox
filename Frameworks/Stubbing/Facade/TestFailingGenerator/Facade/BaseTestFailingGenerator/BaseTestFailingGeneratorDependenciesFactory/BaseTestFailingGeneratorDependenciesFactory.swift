public protocol BaseTestFailingGeneratorDependenciesFactory {
    func baseTestFailingGeneratorDependencies(
        configuredDynamicLookupGeneratorProvider: ConfiguredDynamicLookupGeneratorProvider)
        -> BaseTestFailingGeneratorDependencies
}
