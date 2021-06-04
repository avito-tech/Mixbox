import UIKit
import MixboxUiKit

final class ScreenshotDHashLabelsTestsView: UIView {
    private let catView = UIImageView(image: UIImage(named: "imagehash_cats/imagehash_cat_original"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        catView.backgroundColor = .red
        catView.accessibilityIdentifier = "catView"
        catView.contentMode = .scaleAspectFit
        addSubview(catView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let image = catView.image {
            let frameForCat = bounds.mb_shrinked(insets())
            
            let imageHeightToWidth = image.size.height / image.size.width
            
            if frameForCat.size.height / frameForCat.size.width < imageHeightToWidth {
                catView.mb_width = frameForCat.height / imageHeightToWidth
                catView.mb_height = frameForCat.height
            } else {
                catView.mb_width = frameForCat.width
                catView.mb_height = frameForCat.width * imageHeightToWidth
            }
            
            catView.center = frameForCat.mb_center
        }
    }
    
    private func insets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return safeAreaInsets + UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        } else {
            return UIEdgeInsets(top: 50, left: 0, bottom: 20, right: 0)
        }
    }
}
