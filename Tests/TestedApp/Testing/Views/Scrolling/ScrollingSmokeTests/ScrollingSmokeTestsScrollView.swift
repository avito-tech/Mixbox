import UIKit
import TestsIpc

final class ScrollingSmokeTestsScrollView: UIScrollView, ScrollingSmokeTestsView {
    private let firstView = UILabel()
    private let secondView = UILabel()
    private let thirdView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for (index, view) in [firstView, secondView, thirdView].enumerated() {
            addSubview(view)
            view.accessibilityIdentifier = ScrollingSmokeTestsViewConstants.viewIds[index]
            view.text = ScrollingSmokeTestsViewConstants.viewTexts[index]
            view.textAlignment = .center
        }
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentSize = CGSize(
            width: frame.width,
            height: frame.height * CGFloat(ScrollingSmokeTestsViewConstants.contentHeightInScreens)
        )
        
        firstView.frame = CGRect.mb_init(
            left: frame.mb_left,
            right: frame.mb_right,
            centerY: frame.mb_centerY,
            height: ScrollingSmokeTestsViewConstants.viewHeight
        )
        
        secondView.frame = CGRect.mb_init(
            left: frame.mb_left,
            right: frame.mb_right,
            centerY: frame.mb_centerY + frame.height * CGFloat((ScrollingSmokeTestsViewConstants.contentHeightInScreens - 1) / 2),
            height: ScrollingSmokeTestsViewConstants.viewHeight
        )
        
        thirdView.frame = CGRect.mb_init(
            left: frame.mb_left,
            right: frame.mb_right,
            centerY: frame.mb_centerY + frame.height * CGFloat(ScrollingSmokeTestsViewConstants.contentHeightInScreens - 1),
            height: ScrollingSmokeTestsViewConstants.viewHeight
        )
    }
}
