import MixboxUiTestsFoundation

// TODO: Make an abstraction for the app
final class Apps {
    var mainUiKitHierarchy: PageObjectRegistrar
    var mainXcui: PageObjectRegistrar
    
    var settings: PageObjectRegistrar
    var springboard: PageObjectRegistrar
    
    init(
        mainUiKitHierarchy: PageObjectDependenciesFactory,
        mainXcui: PageObjectDependenciesFactory,
        settings: PageObjectDependenciesFactory,
        springboard: PageObjectDependenciesFactory)
    {
        self.mainUiKitHierarchy = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: mainUiKitHierarchy
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
