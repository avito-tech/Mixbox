import UIKit
import MixboxTestability

final class FailuresTestsView: UIView {
    private let purityView = UIView()
    private let faithView = UIView()
    private let bloodView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(purityView)
        addSubview(faithView)
        addSubview(bloodView)
        
        purityView.backgroundColor = .white
        faithView.backgroundColor = .blue
        bloodView.backgroundColor = .red
        
        // To have multiple match error
        purityView.accessibilityIdentifier = "multipleMatchesFailureView"
        faithView.accessibilityIdentifier = "multipleMatchesFailureView"
        bloodView.accessibilityIdentifier = "multipleMatchesFailureView"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        purityView.layout(
            left: bounds.mb_left,
            right: bounds.mb_right,
            top: bounds.mb_top,
            height: ceil(bounds.height / 3)
        )
        faithView.layout(
            left: bounds.mb_left,
            right: bounds.mb_right,
            top: purityView.mb_bottom,
            height: ceil(bounds.height / 3)
        )
        bloodView.layout(
            left: bounds.mb_left,
            right: bounds.mb_right,
            top: faithView.mb_bottom,
            bottom: bounds.mb_bottom
        )
    }
}
