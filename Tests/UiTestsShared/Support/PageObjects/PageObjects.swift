final class PageObjects: BasePageObjects {
    var generic: GenericPageObject { return pageObject() }
    
    var checksTestsScreen: ChecksTestsScreen { return pageObject() }
    
    var networkStubbingTestsViewPageObject: NetworkStubbingTestsViewPageObject { return pageObject() }
    
    var screenshotTestsView: MainAppScreen<ScreenshotTestsViewPageObject> { return mainAppScreen() }
    
    var hierarchyTestsView: MainAppScreen<HierarchyTestsViewPageObject> { return mainAppScreen() }
    
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
