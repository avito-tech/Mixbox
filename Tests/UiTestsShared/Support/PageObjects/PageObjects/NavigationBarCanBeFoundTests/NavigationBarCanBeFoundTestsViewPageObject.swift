import Foundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxUiKit

public final class NavigationBarCanBeFoundTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "NavigationBarCanBeFoundTestsView"
    
    public var rootViewController: ViewElement {
        return element("rootViewController") { element in
            element.id == "NavigationBarCanBeFoundTestsView"
        }
    }
    
    public var nestedViewController: ViewElement {
        return element("nestedViewController") { element in
            element.id == "NestedViewController"
        }
    }
    
    public var defaultBackButton: ViewElement {
        return element("defaultBackButton") { element in
            if iosVersion.majorVersion >= 14 {
                return element.isInstanceOf("_UIButtonBarButton") && element.hasDirectSubview { element in
                    element.isInstanceOf("_UIModernBarButton") && element.text == "Back"
                }
            } else {
                // Theoretically can be a part of Mixbox frameworks:
                return element.isInstanceOf("_UIButtonBarButton") && element.hasDirectSubview { element in
                    element.isInstanceOf("_UIBackButtonContainerView")
                }
            }
        }
    }
    
    public func customBarButton(title: String) -> ViewElement {
        return element("customBarButton(title: \(title.debugDescription))") { element in
            element.isInstanceOf("_UIButtonBarButton") && element.hasDirectSubview { element in
                element.text == title && element.isInstanceOf("_UIModernBarButton")
            }
        }
    }
}
