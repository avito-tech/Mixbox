import UIKit

final class TapIndicatorButton: UIButton {
    var onTap: (() -> ())?
    
    var tapped: Bool {
        get {
            return mb_testability_customValues["isTapped"] ?? false
        }
        set {
            mb_testability_customValues["isTapped"] = newValue
        }
    }
    
    init(
        onTap: (() -> ())? = nil
    ) {
        self.onTap = onTap
        
        super.init(frame: .zero)
        
        addTarget(self, action: #selector(handleTouchUpInside(_:)), for: .touchUpInside)
        
        reset()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        tapped = false
        backgroundColor = .blue
    }
    
    @objc private func handleTouchUpInside(_ recognizer: UITapGestureRecognizer) {
        tapped = true
        backgroundColor = .green
        onTap?()
    }
}
