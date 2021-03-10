public protocol BaseTestFailingGeneratorDependenciesFactory {
    func baseTestFailingGeneratorDependencies(
        configuredDynamicLookupGeneratorProvider: ConfiguredDynamicLookupGeneratorProvider,
        testFailingGeneratorObserver: TestFailingGeneratorObserver)
        -> BaseTestFailingGeneratorDependencies
}

extension BaseTestFailingGeneratorDependenciesFactory {
    public func baseTestFailingGeneratorDependencies(
        configuredDynamicLookupGeneratorProvider: ConfiguredDynamicLookupGeneratorProvider)
        -> BaseTestFailingGeneratorDependencies
    {
        return baseTestFailingGeneratorDependencies(
            configuredDynamicLookupGeneratorProvider: configuredDynamicLookupGeneratorProvider,
            testFailingGeneratorObserver: NoopTestFailingGeneratorObserver()
        )
    }
}
