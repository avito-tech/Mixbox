import MixboxUiTestsFoundation
import MixboxIpc
import XCTest
import MixboxFoundation

class HierarchySourcesTests: TestCase {
    func test() {
        openScreen(name: "HierarchySourcesTestsView")
        
        let text = "The text of the label"
        pageObjects.appUiKitHierarchy.label(id: "label").assertHasText(text)
        pageObjects.appXcuiHierarchy.label(id: "label").assertHasText(text)
        
        pageObjects.appUiKitHierarchy.label(id: "label").assertHasAccessibilityLabel(text)
        pageObjects.appXcuiHierarchy.label(id: "label").assertHasAccessibilityLabel(text)
        
        pageObjects.appUiKitHierarchy.label(accessibilityLabel: text).assertIsDisplayed()
        pageObjects.appXcuiHierarchy.label(accessibilityLabel: text).assertIsDisplayed()
    }
}

private final class AppScreen: BasePageObjectWithDefaultInitializer {
    func label(id: String) -> LabelElement {
        return element("label \(id)") { element in element.id == id }
    }
    
    func label(accessibilityLabel: String) -> LabelElement {
        return element("label \(accessibilityLabel)") { element in element.accessibilityLabel == accessibilityLabel }
    }
}

private final class SpringboardScreen: BasePageObjectWithDefaultInitializer {
    func appIcon(possibleTitles: [String]) -> ViewElement {
        let elementName = "icon of the app with name \(possibleTitles.joined(separator: " or "))"
        return element(elementName) { element in
            element.type == .icon
                && OrMatcher(possibleTitles.map { element.accessibilityLabel == $0 })
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
                && OrMatcher(possibleTitles.map { element.accessibilityLabel == $0 })
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
