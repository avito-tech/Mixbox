import UIKit

final class LabelWithClosures: UILabel {
    var onTap: (() -> ())?
    var onLongPress: (() -> ())?
    
    var onSwipeDown: (() -> ())?
    var onSwipeUp: (() -> ())?
    var onSwipeLeft: (() -> ())?
    var onSwipeRight: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        
        do {
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeLeft(_:)))
            swipeGestureRecognizer.direction = .left
            addGestureRecognizer(swipeGestureRecognizer)
        }
        do {
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeRight(_:)))
            swipeGestureRecognizer.direction = .right
            addGestureRecognizer(swipeGestureRecognizer)
        }
        do {
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeUp(_:)))
            swipeGestureRecognizer.direction = .up
            addGestureRecognizer(swipeGestureRecognizer)
        }
        do {
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeDown(_:)))
            swipeGestureRecognizer.direction = .down
            addGestureRecognizer(swipeGestureRecognizer)
        }
        
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
    
    @objc private func onSwipeLeft(_ recognizer: UISwipeGestureRecognizer) {
        onSwipeLeft?()
    }
    
    @objc private func onSwipeRight(_ recognizer: UISwipeGestureRecognizer) {
        onSwipeRight?()
    }
    
    @objc private func onSwipeUp(_ recognizer: UISwipeGestureRecognizer) {
        onSwipeUp?()
    }
    
    @objc private func onSwipeDown(_ recognizer: UISwipeGestureRecognizer) {
        onSwipeDown?()
    }
}
