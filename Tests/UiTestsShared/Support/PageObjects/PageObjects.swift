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
final class PageObjects: BasePageObjects {
    var generic: GenericPageObject { return pageObject() }
    
    var checksTestsView: MainAppScreen<ChecksTestsViewPageObject> { return mainAppScreen() }
    
    var networkStubbingTestsView: MainAppScreen<NetworkStubbingTestsViewPageObject> { return mainAppScreen() }
    
    var screenshotTestsView: MainAppScreen<ScreenshotTestsViewPageObject> { return mainAppScreen() }
    
    var hierarchyTestsView: MainAppScreen<HierarchyTestsViewPageObject> { return mainAppScreen() }
    
    var keyboardEventInjectorImplTestsView: MainAppScreen<KeyboardEventInjectorImplTestsViewPageObject> { return mainAppScreen() }
    
    var touchesTestsView: MainAppScreen<TouchesTestsViewPageObject> { return mainAppScreen() }
    
    var actionsTestsView: MainAppScreen<ActionsTestsViewPageObject> { return mainAppScreen() }
    
    var locatorsPerformanceTestsView: MainAppScreen<LocatorsPerformanceTestsViewPageObject> { return mainAppScreen() }
    
    var locatorsTestsView: MainAppScreen<LocatorsTestsViewPageObject> { return mainAppScreen() }
    
    var waitingForQuiescenceTestsView: MainAppScreen<WaitingForQuiescenceTestsViewPageObject> { return mainAppScreen() }
    
    private func mainAppScreen<PageObjectType>() -> MainAppScreen<PageObjectType> {
        return MainAppScreen(
            real: apps.mainUiKitHierarchy.pageObject(),
            xcui: apps.mainXcuiHierarchy.pageObject(),
            default: apps.mainDefaultHierarchy.pageObject()
        )
    }
}
