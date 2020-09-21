import MixboxUiTestsFoundation

// See extension to OpenableScreen
protocol DefaultElementFactoryProvider {
    var defaultElementFactory: ElementFactory { get }
}

final class MainAppScreen<PageObjectType: BasePageObjectWithDefaultInitializer>: DefaultElementFactoryProvider {
    let uikit: PageObjectType // page object with real hierarchy
    let xcui: PageObjectType // page object with xcui hierarchy
    let `default`: PageObjectType // real hierarchy in GrayBox tests, xcui hierarchy in BlackBoxTests
    
    var everyKindOfHierarchy: [PageObjectType] {
        return [uikit, xcui]
    }
    
    func forEveryKindOfHierarchy(body: (PageObjectType) -> ()) {
        everyKindOfHierarchy.forEach(body)
    }
    
    var defaultElementFactory: ElementFactory {
        return `default`
    }
    
    init(uikit: PageObjectType, xcui: PageObjectType, default: PageObjectType) {
        self.uikit = uikit
        self.xcui = xcui
        self.default = `default`
    }
}

extension MainAppScreen: OpenableScreen where PageObjectType: OpenableScreen {
    var viewName: String {
        assert(uikit.viewName == xcui.viewName)
        return uikit.viewName
    }
}
