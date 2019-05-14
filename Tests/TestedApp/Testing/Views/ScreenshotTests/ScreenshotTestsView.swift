import UIKit
import MixboxUiKit
import TestsIpc

final class ScreenshotTestsView: UIView {
    private let views: [UIView]
    
    override init(frame: CGRect) {
        views = (0..<ScreenshotTestsConstants.viewsCount).map { index in
            let view = UIView()
            view.accessibilityIdentifier = ScreenshotTestsConstants.viewId(index: index)
            view.backgroundColor = ScreenshotTestsConstants.color(index: index)
            return view
        }
        
        super.init(frame: frame)
        
        backgroundColor = .white
        
        views.forEach {
            addSubview($0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let squareSide = Int(sqrt(Double(views.count)))
        let maxSize = ScreenshotTestsConstants.viewSize(index: views.count - 1)
        
        for (i, view) in views.enumerated() {
            let row = CGFloat((i % squareSide) - squareSide / 2)
            let column = CGFloat((i / squareSide) - squareSide / 2)
            let offset = CGVector(
                dx: (maxSize.width + 1) * row,
                dy: (maxSize.height + 1) * column
            )
            
            view.mb_size = ScreenshotTestsConstants.viewSize(index: i).mb_floor()
            view.center = (bounds.mb_center - offset)
            view.mb_origin = view.mb_origin.mb_floor() // avoid blending
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

