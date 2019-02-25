import UIKit

final class ExpandingView: UIView {
    let expandButton = ButtonWithClosures()
    let collapseButton = ButtonWithClosures()
    let label = UILabel()
    
    var expanded = false {
        didSet {
            updateLabel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        expandButton.onTap = { [weak self] in
            self?.expanded = true
            self?.setNeedsLayout()
        }
        expandButton.accessibilityIdentifier = "expandButton"
        
        collapseButton.onTap = { [weak self] in
            self?.expanded = false
            self?.setNeedsLayout()
        }
        collapseButton.accessibilityIdentifier = "collapseButton"
        
        label.backgroundColor = .gray
        label.accessibilityIdentifier = "expandingLabel"
        
        addSubview(expandButton)
        addSubview(collapseButton)
        addSubview(label)
        
        updateLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        expandButton.layout(
            top: bounds.mb_top,
            bottom: bounds.mb_bottom,
            left: bounds.mb_left,
            width: bounds.height
        )
        collapseButton.layout(
            top: bounds.mb_top,
            bottom: bounds.mb_bottom,
            left: expandButton.mb_right,
            width: bounds.height
        )
        
        label.layout(
            left: collapseButton.mb_right,
            right: bounds.mb_right,
            top: bounds.mb_top,
            height: expanded ? bounds.height : bounds.height / 2
        )
    }
    
    private func updateLabel() {
        label.text = "expanded: \(expanded)"
    }
}
