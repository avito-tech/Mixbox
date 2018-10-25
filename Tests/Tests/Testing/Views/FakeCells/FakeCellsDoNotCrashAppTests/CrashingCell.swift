import UIKit

final class CrashingCell: UICollectionViewCell {
    var crashPlace: Int?
    
    private func crash(line: UInt = #line) {
        if Int(line) == crashPlace || crashPlace == 0 {
            CrashingCellException().raise()
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        crash()
        
        return super.sizeThatFits(size)
    }
    
    override func layoutSubviews() {
        crash()
        
        super.layoutSubviews()
    }
    
    override var reuseIdentifier: String? {
        crash()
        
        return super.reuseIdentifier
    }
    
    override func prepareForReuse() {
        crash()
        
        super.prepareForReuse()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        crash()
        
        super.apply(layoutAttributes)
    }
    
    override func willTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        crash()
        
        super.willTransition(from: oldLayout, to: newLayout)
    }
    
    override func didTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        crash()
        
        super.didTransition(from: oldLayout, to: newLayout)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        crash()
        
        return super.preferredLayoutAttributesFitting(layoutAttributes)
    }
}
