import UIKit
import MixboxUiKit

final class ScreenshotDHashLabelsTestsView: UIView {
    private let catView = UIImageView(image: UIImage(named: "imagehash_cat_original"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        catView.translatesAutoresizingMaskIntoConstraints = false
        catView.accessibilityIdentifier = "catView"
        addSubview(catView)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(
            NSLayoutConstraint(
                item: catView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1,
                constant: 0
            )
        )
        constraints.append(
            NSLayoutConstraint(
                item: catView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1,
                constant: 0
            )
        )
        constraints.append(
            NSLayoutConstraint(
                item: catView,
                attribute: .width,
                relatedBy: .equal,
                toItem: catView,
                attribute: .height,
                multiplier: (catView.image?.size.width ?? 0) / (catView.image?.size.height ?? 1),
                constant: 0
            )
        )
        constraints.append(
            NSLayoutConstraint(
                item: catView,
                attribute: .height,
                relatedBy: .equal,
                toItem: self,
                attribute: .height,
                multiplier: 1,
                constant: -100
            )
        )
        constraints.forEach{ $0.isActive = true }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

