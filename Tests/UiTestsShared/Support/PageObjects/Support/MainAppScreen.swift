import MixboxUiTestsFoundation

// See extension to OpenableScreen
protocol DefaultPageObjectElementRegistrarProvider {
    var defaultPageObjectElementRegistrar: PageObjectElementRegistrar { get }
}

final class MainAppScreen<PageObjectType: BasePageObjectWithDefaultInitializer>: DefaultPageObjectElementRegistrarProvider {
    let real: PageObjectType // page object with real hierarchy
    let xcui: PageObjectType // page object with xcui hierarchy
    let `default`: PageObjectType // real hierarchy in GrayBox tests, xcui hierarchy in BlackBoxTests
    
    var everyKindOfHierarchy: [PageObjectType] {
        return [real, xcui]
    }
    
    func forEveryKindOfHierarchy(body: (PageObjectType) -> ()) {
        everyKindOfHierarchy.forEach(body)
    }
    
    var defaultPageObjectElementRegistrar: PageObjectElementRegistrar {
        return `default`
    }
    
    init(real: PageObjectType, xcui: PageObjectType, default: PageObjectType) {
        self.real = real
        self.xcui = xcui
        self.default = `default`
    }
}

extension MainAppScreen: OpenableScreen where PageObjectType: OpenableScreen {
    var viewName: String {
        assert(real.viewName == xcui.viewName)
        return real.viewName
    }
}
