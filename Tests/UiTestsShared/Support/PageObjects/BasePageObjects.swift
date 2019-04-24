import MixboxUiTestsFoundation

// TODO: Make an abstraction for the app
final class Apps {
    var mainRealHierarchy: PageObjectRegistrar
    var mainXcui: PageObjectRegistrar
    
    var settings: PageObjectRegistrar
    var springboard: PageObjectRegistrar
    
    init(
        mainRealHierarchy: PageObjectDependenciesFactory,
        mainXcui: PageObjectDependenciesFactory,
        settings: PageObjectDependenciesFactory,
        springboard: PageObjectDependenciesFactory)
    {
        self.mainRealHierarchy = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: mainRealHierarchy
        )
        self.mainXcui = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: mainXcui
        )
        self.settings = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: settings
        )
        self.springboard = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: springboard
        )
    }
}

public class BasePageObjects: PageObjectsMarkerProtocol {
    let apps: Apps
    fileprivate let defaultPageObjectRegistrar: PageObjectRegistrar
    
    init(apps: Apps) {
        self.apps = apps
        self.defaultPageObjectRegistrar = apps.mainXcui
    }

    func pageObject<PageObjectType: PageObjectWithDefaultInitializer>() -> PageObjectType {
        return defaultPageObjectRegistrar.pageObject(PageObjectType.init)
    }
}
