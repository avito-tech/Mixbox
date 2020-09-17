#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

extension UIView {
    @objc override open func mb_testability_isDefinitelyHidden() -> Bool {
        return self.isDefinitelyHidden(alphaThreshold: 0.01)
    }
    
    private func isDefinitelyHidden(alphaThreshold: CGFloat) -> Bool {
        var pointer: UIView? = self
        
        while let view = pointer {
            // "Fake cells" are what we instantiate for the cells that are not visible in collection view.
            // Fake cells can be reused, isHidden can be == true (and setting it to false can not work).
            //
            // We treat them as not directly/or definitely hidden, because they (not the exact instances,
            // but the cells they prepresent) can appear on screen after scrolling.
            //
            // This is how collection view works. So we should ignore isHidden for them.
            let parentCollectionView = (view as? UICollectionViewCell)?.mb_fakeCellInfo?.parentCollectionView
            
            let currentViewIsHidden: Bool
            if let cell = view as? UICollectionViewCell, cell.mb_isFakeCell() {
                // Fake cells can have isHidden = true and have zero size.
                currentViewIsHidden = view.alpha < alphaThreshold
            } else {
                currentViewIsHidden = view.isHidden
                    || view.alpha < alphaThreshold
                    || view.frame.width == 0
                    || view.frame.height == 0
            }
            
            if currentViewIsHidden {
                return true
            }
            
            pointer = view.superview ?? parentCollectionView
        }
        
        return false
    }
}

#endif
