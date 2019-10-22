import UIKit

class View: UIView {
    let view = View()
    let label = UILabel()
    let button = UIButton()
    let textView = UITextView()
    let textField = UITextField()
    let views: [String: UIView]
    
    override init(frame: CGRect) {
        views = [
            "view": view,
            "label": label,
            "button": button,
            "textView": textView,
            "textField": textField
        ]
        
        super.init(frame: frame)
        
        views.forEach { id, view in
            addSubview(view)
            view.accessibilityIdentifier = id
        }
        
        view.accessibilityValue = "view.accessibilityValue"
        view.accessibilityLabel = "view.accessibilityLabel"
        
        label.text = "label.text"
        
        let buttonStates: [String: UIControl.State] = [
            "normal": .normal,
            "highlighted": .highlighted,
            "disabled": .disabled,
            "selected": .selected,
            "focused": .focused,
            "application": .application,
            "reserved": .reserved
        ]
        
        for (name, state) in buttonStates {
            button.setTitle("button.title.\(name)", for: state)
            button.setTitleColor(.black, for: state)
        }
        
        textView.text = "textView.text"
        textField.text = "textField.text"
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var y: CGFloat = 60
        
        func nextRect(height: CGFloat = 40) -> CGRect {
            let rect = CGRect(x: 0, y: y, width: bounds.width, height: height)
            y += height
            return rect
        }
        
        views.values.forEach { $0.frame = nextRect() }
    }
}
