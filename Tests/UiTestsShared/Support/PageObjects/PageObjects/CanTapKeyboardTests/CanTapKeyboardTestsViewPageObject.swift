import MixboxUiTestsFoundation
import MixboxTestsFoundation

public final class CanTapKeyboardTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "CanTapKeyboardTestsView"
    
    public var textField: ViewElement {
        return element("textField") {
            $0.id == "textField"
        }
    }
    
    public var statusLabel: LabelElement {
        return element("statusLabel") {
            $0.id == "statusLabel"
        }
    }
    
    public var doneButton: ViewElement {
        return element("doneButton") {
            $0.customValues["MixboxBuiltinCustomValue.UIKBKey.name"] == "Return-Key" && $0.isDirectSubviewOf {
                $0.type == .keyboard && $0.hasNoSuperview
            }
        }
    }
}
