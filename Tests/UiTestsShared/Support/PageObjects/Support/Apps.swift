import MixboxUiTestsFoundation

// TODO: Make an abstraction for the app
final class Apps {
    var mainUiKitHierarchy: PageObjectRegistrar
    var mainXcuiHierarchy: PageObjectRegistrar
    var mainDefaultHierarchy: PageObjectRegistrar
    
    var settings: PageObjectRegistrar
    var springboard: PageObjectRegistrar
    
    init(
        mainUiKitHierarchy: PageObjectDependenciesFactory,
        mainXcuiHierarchy: PageObjectDependenciesFactory,
        mainDefaultHierarchy: PageObjectDependenciesFactory,
        settings: PageObjectDependenciesFactory,
        springboard: PageObjectDependenciesFactory)
    {
        self.mainUiKitHierarchy = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: mainUiKitHierarchy
        )
        self.mainXcuiHierarchy = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: mainXcuiHierarchy
        )
        self.mainDefaultHierarchy = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: mainDefaultHierarchy
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
    
    init(apps: Apps) {
        self.apps = apps
    }

    func pageObject<PageObjectType: PageObjectWithDefaultInitializer>() -> PageObjectType {
        return apps.mainDefaultHierarchy.pageObject(PageObjectType.init)
    }
}
