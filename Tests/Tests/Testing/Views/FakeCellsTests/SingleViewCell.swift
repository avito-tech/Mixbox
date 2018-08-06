import UIKit

final class SingleViewCell<V: UIView>: UICollectionViewCell {
    let view = V()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return view.sizeThatFits(size)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        view.frame = bounds
    }
}
