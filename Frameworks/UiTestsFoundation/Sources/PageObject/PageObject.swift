public protocol PageObject: AnyObject {
}

public protocol PageObjectWithDefaultInitializer: PageObject {
    init(pageObjectDependenciesFactory: PageObjectDependenciesFactory)
}
