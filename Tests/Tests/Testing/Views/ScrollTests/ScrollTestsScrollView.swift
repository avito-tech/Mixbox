import UIKit

final class ScrollTestsScrollView: UIScrollView {
    private let firstView = UILabel()
    private let secondView = UILabel()
    private let thirdView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for (index, view) in [firstView, secondView, thirdView].enumerated() {
            addSubview(view)
            view.accessibilityIdentifier = ScrollTests.viewIds[index]
            view.text = ScrollTests.viewTexts[index]
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
            height: frame.height * CGFloat(ScrollTests.contentHeightInScreens)
        )
        
        firstView.frame = CGRect(
            left: frame.mb_left,
            right: frame.mb_right,
            centerY: frame.mb_centerY,
            height: ScrollTests.viewHeight
        )
        
        secondView.frame = CGRect(
            left: frame.mb_left,
            right: frame.mb_right,
            centerY: frame.mb_centerY + frame.height * CGFloat((ScrollTests.contentHeightInScreens - 1) / 2),
            height: ScrollTests.viewHeight
        )
        
        thirdView.frame = CGRect(
            left: frame.mb_left,
            right: frame.mb_right,
            centerY: frame.mb_centerY + frame.height * CGFloat(ScrollTests.contentHeightInScreens - 1),
            height: ScrollTests.viewHeight
        )
        
    }
}
