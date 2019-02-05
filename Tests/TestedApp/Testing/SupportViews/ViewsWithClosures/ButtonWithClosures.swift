import UIKit

final class ButtonWithClosures: UIButton {
    var onTap: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
        onTap?()
    }
}
