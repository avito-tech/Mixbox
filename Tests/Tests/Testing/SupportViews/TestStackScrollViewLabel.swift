import UIKit

final class TestStackScrollViewLabel: UILabel {
    var onTap: (() -> ())?
    var onLongPress: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(onLongPress(_:))
        )
        longPressGestureRecognizer.minimumPressDuration = 1.0
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
        onTap?()
    }
    
    @objc private func onLongPress(_ recognizer: UILongPressGestureRecognizer) {
        onLongPress?()
    }
}
