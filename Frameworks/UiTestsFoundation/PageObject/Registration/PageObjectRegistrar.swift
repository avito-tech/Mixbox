// Should duplicate initializer of BasePageObject,
// because it makes writing tests easier
public typealias BasePageObjectInitializer<PageObjectType> = (PageObjectDependenciesFactory) -> PageObjectType

public protocol PageObjectRegistrar: class {
    func pageObject<PageObjectType>(
        _ initializer: BasePageObjectInitializer<PageObjectType>)
        -> PageObjectType
}

public extension PageObjectRegistrar {
    func pageObject<PageObjectType: PageObjectWithDefaultInitializer>()
        -> PageObjectType
    {
        return pageObject(PageObjectType.init)
    }
}
