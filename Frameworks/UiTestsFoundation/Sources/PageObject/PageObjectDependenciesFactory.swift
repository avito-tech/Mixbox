import MixboxTestsFoundation

public protocol PageObjectDependenciesFactory: AnyObject {
    var di: TestFailingDependencyResolver { get }
}
 
extension PageObjectDependenciesFactory {
    public var pageObjectElementCoreFactory: PageObjectElementCoreFactory { di.resolve() }
    public var matcherBuilder: ElementMatcherBuilder { di.resolve() }
    public var interactionSettingsDefaultsProvider: InteractionSettingsDefaultsProvider { di.resolve() }
    public var matcherBulder: ElementMatcherBuilder { di.resolve() }
}
