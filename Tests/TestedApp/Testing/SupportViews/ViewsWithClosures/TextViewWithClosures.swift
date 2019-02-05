import UIKit

final class TextViewWithClosures: UITextView, UITextViewDelegate {
    var onInput: ((_ text: String?) -> ())?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        onInput?(textView.text)
    }
}
