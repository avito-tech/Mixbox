import UIKit

final class View: UIView {
    private let view = UIView()
    private let label = UILabel()
    private let button = UIButton()
    private let textView = UITextView()
    private let textField = UITextField()
    private let startTrackingKeyHidEventsButton = UIButton()
    private let views: [String: UIView]
    
    private let keyHidEventsTracker = KeyHidEventsTracker()
    
    override init(frame: CGRect) {
        views = [
            "view": view,
            "label": label,
            "button": button,
            "textView": textView,
            "textField": textField,
            "startTrackingKeyHidEventsButton": startTrackingKeyHidEventsButton
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
        
        startTrackingKeyHidEventsButton.addTarget(
            self,
            action: #selector(handleStartTrackingKeyHidEventsButtonTouchedUpInside),
            for: UIControl.Event.touchUpInside
        )
        
        for (_, state) in buttonStates {
            startTrackingKeyHidEventsButton.setTitle("Debug IOHID", for: state)
            startTrackingKeyHidEventsButton.setTitleColor(.black, for: state)
        }
        
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
    
    @objc func handleStartTrackingKeyHidEventsButtonTouchedUpInside(_ sender: AnyObject) {
        keyHidEventsTracker.startTracking()
    }
}
