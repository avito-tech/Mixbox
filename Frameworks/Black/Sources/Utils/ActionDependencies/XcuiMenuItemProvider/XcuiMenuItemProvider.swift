import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest

public final class XcuiMenuItemProvider: MenuItemProvider {
    private let applicationProvider: ApplicationProvider
    
    public init(applicationProvider: ApplicationProvider) {
        self.applicationProvider = applicationProvider
    }
    
    public func menuItem(possibleTitles: [String]) -> MenuItem {
        let xcuiElementQuery = applicationProvider.application.menuItems.matching(
            NSPredicate(
                block: { [possibleTitles] snapshot, _ -> Bool in
                    if let snapshot = snapshot as? XCElementSnapshot {
                        return possibleTitles.contains { element in
                            snapshot.label == element
                        }
                    } else {
                        return false
                    }
                }
            )
        )
        
        return XcuiElementMenuItem(
            xcuiElement: xcuiElementQuery.firstMatch
        )
    }
}
