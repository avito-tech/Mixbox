import UIKit

final class ChecksTestsView: TestStackScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        accessibilityIdentifier = "ChecksTestsView"
        
        addLabel(id: "checkText0") {
            $0.text = "Полное соответствие"
        }
        addLabel(id: "checkText1") {
            $0.text = "Частичное соответствие"
        }
        
        addLabel(id: "hasValue0") {
            $0.accessibilityValue = "Accessibility Value"
        }
        
        addLabel(id: "isNotDisplayed0") {
            $0.isHidden = true
        }
        addLabel(id: "isNotDisplayed1") {
            $0.alpha = 0
        }
        
        addLabel(id: "isDisplayed0") { _ in
            // дефолтно
        }
        
        addButton(id: "isEnabled0") {
            $0.isEnabled = true
        }
        
        addButton(id: "isDisabled0") {
            $0.isEnabled = false
        }
        
        add(view: ExpandingView(), id: "expandingView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
