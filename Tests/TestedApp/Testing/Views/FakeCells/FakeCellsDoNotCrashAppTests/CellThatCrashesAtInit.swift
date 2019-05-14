import UIKit

final class CellThatCrashesAtInit: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        CrashingCellException().raise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
