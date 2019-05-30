public protocol PageObject: class {
}

public protocol PageObjectWithDefaultInitializer: class, PageObject {
    init(pageObjectDependenciesFactory: PageObjectDependenciesFactory)
}
