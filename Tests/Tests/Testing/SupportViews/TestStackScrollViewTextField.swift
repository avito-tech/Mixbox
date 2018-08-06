import UIKit

final class TestStackScrollViewTextField: UITextField {
    var onInput: ((_ text: String?) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(
            self,
            action: #selector(onInput(_:)),
            for: .editingChanged
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onInput(_ sender: AnyObject) {
        onInput?(text)
    }
}
