#if MIXBOX_ENABLE_IN_APP_SERVICES

import Foundation
import MixboxTestability

@nonobjc extension UIView {
    var isDefinitelyHidden: Bool {
        return self.isDefinitelyHidden(alphaThreshold: 0.01)
    }
    
    // TODO: Rename/refactor.
    // The name should make the reasons to use the function obvious.
    // And SRP seems to be violated.
    //
    // There are multiple reasons to use this property (1 & 2 are quite same though):
    // 1. Fast check if view is hidden before performing an expensive check.
    // 2. Ignore temporary cells in collection view that are used for animations.
    // 3. Check if we can scroll to the element and then perform check for visibility.
    //    E.g.: isDefinitelyHidden == true => we should not even try to scroll
    //          isDefinitelyHidden == false => we should consider scrolling to the view.
    //
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
                    || view.frame.mb_hasZeroArea()
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
