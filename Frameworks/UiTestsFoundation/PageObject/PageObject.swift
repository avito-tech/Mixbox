public protocol PageObject: class {
}

public protocol PageObjectWithDefaultInitializer: PageObject {
    init(pageObjectDependenciesFactory: PageObjectDependenciesFactory)
}
