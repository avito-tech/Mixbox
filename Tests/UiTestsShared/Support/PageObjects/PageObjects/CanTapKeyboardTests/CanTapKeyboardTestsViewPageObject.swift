import MixboxUiTestsFoundation
import MixboxTestsFoundation

public final class SoftwareKeyboardTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "SoftwareKeyboardTestsView"
    
    public var textField: ViewElement {
        return byId("textField")
    }
    
    public var statusLabel: LabelElement {
        return byId("statusLabel")
    }
    
    public var returnKeyButton: ViewElement {
        return element("returnKeyButton") {
            $0.customValues["MixboxBuiltinCustomValue.UIKBKey.name"] == "Return-Key" && $0.isDirectSubviewOf {
                $0.type == .keyboard
            }
        }
    }
    
    public var keyboard: ViewElement {
        return element("keyboard") {
            $0.type == .keyboard
        }
    }
    
    public var viewThatCanBeHiddenBelowKeyboard: ViewElement {
        return byId("viewThatCanBeHiddenBelowKeyboard")
    }
}
