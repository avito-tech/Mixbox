import MixboxTestsFoundation

public protocol PageObjectDependenciesFactory: class {
    var di: TestFailingDependencyResolver { get }
}
 
extension PageObjectDependenciesFactory {
    var pageObjectElementCoreFactory: PageObjectElementCoreFactory { di.resolve() }
    var matcherBuilder: ElementMatcherBuilder { di.resolve() }
    var elementSettingsDefaultsProvider: ElementSettingsDefaultsProvider { di.resolve() }
    var matcherBulder: ElementMatcherBuilder { di.resolve() }
}
