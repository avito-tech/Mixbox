final class MainAppScreen<PageObjectType: BasePageObjectWithDefaultInitializer> {
    let real: PageObjectType // page object with real hierarchy
    let xcui: PageObjectType // page object with xcui hierarchy
    
    var everyKindOfHierarchy: [PageObjectType] {
        return [real, xcui]
    }
    
    func forEveryKindOfHierarchy(body: (PageObjectType) -> ()) {
        everyKindOfHierarchy.forEach(body)
    }
    
    init(real: PageObjectType, xcui: PageObjectType) {
        self.real = real
        self.xcui = xcui
    }
}

extension MainAppScreen: OpenableScreen where PageObjectType: OpenableScreen {
    var viewName: String {
        assert(real.viewName == xcui.viewName)
        return real.viewName
    }
}
