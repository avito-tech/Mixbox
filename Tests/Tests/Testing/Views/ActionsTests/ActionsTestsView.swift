import UIKit

final class ActionsTestsView: UIView {
    let infoLabel = UILabel()
    let scrollView = TestStackScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(infoLabel)
        addSubview(scrollView)
        
        infoLabel.accessibilityIdentifier = "info"
        infoLabel.textAlignment = .center
        infoLabel.textColor = .black
        infoLabel.font = UIFont.systemFont(ofSize: 17)
        
        backgroundColor = .white
        
        scrollView.addLabel(id: "tap") {
            $0.onTap = { [weak self] in
                self?.infoLabel.text = "tap"
            }
        }
        scrollView.addLabel(id: "press") {
            $0.onLongPress = { [weak self] in
                self?.infoLabel.text = "press"
            }
        }
        scrollView.addTextField(id: "text") {
            $0.onInput = { [weak self] text in
                self?.infoLabel.text = "text: \(text ?? "")"
            }
        }
        scrollView.addLabel(id: "swipeLeft") {
            $0.onSwipeLeft = { [weak self] in
                self?.infoLabel.text = "swipeLeft"
            }
        }
        scrollView.addLabel(id: "swipeRight") {
            $0.onSwipeRight = { [weak self] in
                self?.infoLabel.text = "swipeRight"
            }
        }
        scrollView.addLabel(id: "swipeUp") {
            $0.onSwipeUp = { [weak self] in
                self?.infoLabel.text = "swipeUp"
            }
        }
        scrollView.addLabel(id: "swipeDown") {
            $0.onSwipeDown = { [weak self] in
                self?.infoLabel.text = "swipeDown"
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            insets = safeAreaInsets
        } else {
            insets = .zero
        }
        
        scrollView.contentInset = insets
        
        infoLabel.layout(
            left: bounds.mb_left,
            right: bounds.mb_right,
            top: bounds.mb_top + insets.bottom,
            height: 50
        )
        scrollView.layout(
            left: bounds.mb_left,
            right: bounds.mb_right,
            top: infoLabel.mb_bottom,
            bottom: bounds.mb_bottom
        )
    }
}
