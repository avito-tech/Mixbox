public protocol PageObjectElementDependenciesFactory: class {
    func pageObjectElementCoreFactory() -> PageObjectElementCoreFactory
    func matcherBulder() -> ElementMatcherBuilder
}
