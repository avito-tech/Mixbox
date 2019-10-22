import MixboxUiTestsFoundation
import MixboxIpc
import XCTest
import MixboxFoundation

class HierarchySourcesTests: TestCase {
    func test() {
        openScreen(name: "HierarchySourcesTestsView")
        
        pageObjects.appUiKitHierarchy.label("label").assertHasText("The text of the label")
        pageObjects.appXcuiHierarchy.label("label").assertHasText("The text of the label")
        
        // There are currently lots of calls to XCUIApplication() and other usages of singletons
        //
        // XCUIDevice.shared.press(.home)
        //
        // pageObjects.springboard.appIcon(possibleTitles: ["Settings", "सेटिंग्स"]).tap()
        //
        // pageObjects.settings.general().tap()
    }
}

private final class AppScreen: BasePageObjectWithDefaultInitializer {
    func label(_ id: String) -> LabelElement {
        return element("label \(id)") { element in element.id == id }
    }
}

private final class SpringboardScreen: BasePageObjectWithDefaultInitializer {
    func appIcon(possibleTitles: [String]) -> ViewElement {
        let elementName = "icon of the app with name \(possibleTitles.joined(separator: " or "))"
        return element(elementName) { element in
            element.type == .icon
                && OrMatcher(possibleTitles.map { element.label == $0 })
        }
    }
}

private final class SettingsScreen: BasePageObjectWithDefaultInitializer {
    func general() -> ViewElement {
        return cell(possibleTitles: ["General", "Основные"])
    }
    
    func cell(possibleTitles: [String]) -> ViewElement {
        let elementName = "cell with title \(possibleTitles.joined(separator: " or "))"
        return element(elementName) { element in
            element.isSubviewOf { $0.type == .cell }
                && OrMatcher(possibleTitles.map { element.label == $0 })
        }
    }
}

private extension PageObjects {
    var appUiKitHierarchy: AppScreen {
        return apps.mainUiKitHierarchy.pageObject()
    }
    var appXcuiHierarchy: AppScreen {
        return apps.mainXcuiHierarchy.pageObject()
    }
    var settings: SettingsScreen {
        return apps.settings.pageObject()
    }
    var springboard: SpringboardScreen {
        return apps.springboard.pageObject()
    }
}
