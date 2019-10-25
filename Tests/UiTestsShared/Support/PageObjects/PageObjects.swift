// Naming convention:
//
// var {{test case class name}}View: MainAppScreen<{{test case class name}}ViewPageObject> { return mainAppScreen() }
//
// Example:
//
// var touchesTestsView: MainAppScreen<TouchesTestsViewPageObject> { return mainAppScreen() }
//
// If you are testing some `Impl`, for example, `KeyboardEventInjectorImpl`:
//
// {{test case class name}} = KeyboardEventInjectorImplTests
//
// TODO: Change naming accordingly
//
final class PageObjects: BasePageObjects {
    var generic: GenericPageObject { return pageObject() }
    
    var checksTestsScreen: ChecksTestsScreen { return pageObject() }
    
    var networkStubbingTestsViewPageObject: NetworkStubbingTestsViewPageObject { return pageObject() }
    
    var screenshotTestsView: MainAppScreen<ScreenshotTestsViewPageObject> { return mainAppScreen() }
    
    var hierarchyTestsView: MainAppScreen<HierarchyTestsViewPageObject> { return mainAppScreen() }
    
    var keyboardEventInjectorImplTestsView: MainAppScreen<KeyboardEventInjectorImplTestsViewPageObject> { return mainAppScreen() }
    
    var touchesTestsView: MainAppScreen<TouchesTestsViewPageObject> { return mainAppScreen() }
    
    var actionsTestsScreen: ActionsTestsScreen { return pageObject() }
    
    var locatorsPerformanceTestsView: LocatorsPerformanceTestsViewPageObject { return pageObject() }
    
    var locatorsTestsView: MainAppScreen<LocatorsTestsViewPageObject> { return mainAppScreen() }
    
    private func mainAppScreen<PageObjectType>() -> MainAppScreen<PageObjectType> {
        return MainAppScreen(
            real: apps.mainUiKitHierarchy.pageObject(),
            xcui: apps.mainXcuiHierarchy.pageObject(),
            default: apps.mainDefaultHierarchy.pageObject()
        )
    }
}
