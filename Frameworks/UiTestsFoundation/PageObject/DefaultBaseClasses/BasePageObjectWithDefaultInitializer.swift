import MixboxFoundation

open class BasePageObjectWithDefaultInitializer:
    BasePageObject,
    PageObjectWithDefaultInitializer
{
    override public required init(pageObjectDependenciesFactory: PageObjectDependenciesFactory) {
        super.init(
            pageObjectDependenciesFactory: pageObjectDependenciesFactory
        )
    }
}
