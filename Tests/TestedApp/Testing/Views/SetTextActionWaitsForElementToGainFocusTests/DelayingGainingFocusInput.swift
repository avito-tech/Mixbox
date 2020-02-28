import UIKit

final class DelayingGainingFocusInput: UIView {
    private let textView = UITextView()
    private let becomeFirstResponderDelay: TimeInterval
    
    init(becomeFirstResponderDelay: TimeInterval) {
        self.becomeFirstResponderDelay = becomeFirstResponderDelay
        
        super.init(frame: .zero)
        
        textView.accessibilityIdentifier = "textView"
        
        addSubview(textView)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.frame = bounds
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if becomeFirstResponderDelay >= 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + becomeFirstResponderDelay) { [weak self] in
                self?.textView.becomeFirstResponder()
            }
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    // To make becomeFirstResponder() and resignFirstResponder() work
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
}
