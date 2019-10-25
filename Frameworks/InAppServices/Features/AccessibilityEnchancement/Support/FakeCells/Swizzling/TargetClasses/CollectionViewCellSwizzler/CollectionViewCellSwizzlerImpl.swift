#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxTestability
import MixboxFoundation

public final class CollectionViewCellSwizzlerImpl: CollectionViewCellSwizzler {
    private let assertingSwizzler: AssertingSwizzler
    private let onceToken = ThreadUnsafeOnceToken<Void>()
    
    public init(
        assertingSwizzler: AssertingSwizzler)
    {
        self.assertingSwizzler = assertingSwizzler
    }
    
    public func swizzle() {
        _ = onceToken.executeOnce {
            swizzleWhileBeingExecutedOnce()
        }
    }
    
    private func swizzleWhileBeingExecutedOnce() {
        swizzle(
            originalSelector: #selector(UIView.accessibilityElementCount),
            swizzledSelector: #selector(UICollectionViewCell.swizzled_CollectionViewCellSwizzler_accessibilityElementCount),
            shouldAssertIfMethodIsSwizzledOnlyOneTime: false
        )
        
        swizzle(
            originalSelector: #selector(UIView.accessibilityElement(at:)),
            swizzledSelector: #selector(UICollectionViewCell.swizzled_CollectionViewCellSwizzler_accessibilityElement(at:)),
            shouldAssertIfMethodIsSwizzledOnlyOneTime: false
        )
        
        swizzle(
            originalSelector: #selector(getter: UIView.isHidden),
            swizzledSelector: #selector(UICollectionViewCell.swizzled_CollectionViewCellSwizzler_isHidden),
            shouldAssertIfMethodIsSwizzledOnlyOneTime: true
        )
    }
    
    private func swizzle(
        originalSelector: Selector,
        swizzledSelector: Selector,
        shouldAssertIfMethodIsSwizzledOnlyOneTime: Bool)
    {
        assertingSwizzler.swizzle(
            class: UICollectionViewCell.self,
            originalSelector: originalSelector,
            swizzledSelector: swizzledSelector,
            methodType: .instanceMethod,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: shouldAssertIfMethodIsSwizzledOnlyOneTime
        )
    }
}

// Note that we use extension of UIView instead of extension of UICollectionViewCell.
// See comment for same extension in CollectionViewSwizzler for more info.
//
// Specific notes for this code:
// We only modify behavior of fake cells. We don't want to mess with real cells.
extension UIView {
    @objc fileprivate func swizzled_CollectionViewCellSwizzler_accessibilityElementCount() -> Int {
        guard let collectionViewCell = self as? UICollectionViewCell else {
            return swizzled_CollectionViewCellSwizzler_accessibilityElementCount()
        }
        
        if collectionViewCell.mb_isFakeCell() {
            return collectionViewCell.subviews.count
        } else {
            return swizzled_CollectionViewCellSwizzler_accessibilityElementCount()
        }
    }
    
    @objc fileprivate func swizzled_CollectionViewCellSwizzler_accessibilityElement(at index: Int) -> Any? {
        guard let collectionViewCell = self as? UICollectionViewCell else {
            return swizzled_CollectionViewCellSwizzler_accessibilityElement(at: index)
        }
        
        if collectionViewCell.mb_isFakeCell() {
            return collectionViewCell.subviews[index]
        } else {
            return swizzled_CollectionViewCellSwizzler_accessibilityElement(at: index)
        }
    }
    
    @objc fileprivate func swizzled_CollectionViewCellSwizzler_isHidden() -> Bool {
        return isHidden(
            originalImplementation: swizzled_CollectionViewCellSwizzler_isHidden
        )
    }
    
    @nonobjc private func isHidden(
        originalImplementation: () -> Bool)
        -> Bool
    {
        guard let collectionViewCell = self as? UICollectionViewCell else {
            return originalImplementation()
        }
        
        if collectionViewCell.mb_isFakeCell() {
            // We are relatively safe to alter isHidden if the cell is not in hierarchy,
            // E.g. isHidden can be used on fake cells when they are being set up.
            if collectionViewCell.superview == nil {
                // It is usually `true` for real cells and can be `false` for fake cells,
                // if they were obtained from a reuse pool with _isHiddenForReuse == true.
                return true
            }
        }
        
        return originalImplementation()
    }
}

#endif
