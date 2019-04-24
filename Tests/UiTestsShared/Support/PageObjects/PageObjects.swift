final class PageObjects: BasePageObjects {
    var generic: GenericPageObject { return pageObject() }
    
    var checksTestsScreen: ChecksTestsScreen { return pageObject() }
    
    var networkStubbingTestsViewPageObject: NetworkStubbingTestsViewPageObject { return pageObject() }
    
    var screenshotTestsView: MainAppScreen<ScreenshotTestsViewPageObject> { return mainAppScreen() }
    
    private func mainAppScreen<T>() -> MainAppScreen<T> {
        return MainAppScreen(
            real: apps.mainRealHierarchy.pageObject(),
            xcui: apps.mainXcui.pageObject()
        )
    }
}
