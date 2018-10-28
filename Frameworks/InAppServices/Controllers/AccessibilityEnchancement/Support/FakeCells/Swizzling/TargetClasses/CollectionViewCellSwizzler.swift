#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxTestability
import MixboxFoundation

// TODO: Fix linter rule, it should ignore missing colons inside #selector
// swiftlint:disable missing_spaces_after_colon

final class CollectionViewCellSwizzler {
    static func swizzle(shouldAddAssertionForCallingIsHiddenOnFakeCell: Bool) {
        swizzle(
            #selector(UIView.accessibilityElementCount),
            #selector(UICollectionViewCell.swizzled_CollectionViewCellSwizzler_accessibilityElementCount)
        )
        swizzle(
            #selector(UIView.accessibilityElement(at:)),
            #selector(UICollectionViewCell.swizzled_CollectionViewCellSwizzler_accessibilityElement(at:))
        )
        swizzle(
            #selector(getter: UIView.isHidden),
            shouldAddAssertionForCallingIsHiddenOnFakeCell
                ? #selector(UICollectionViewCell.swizzled_CollectionViewCellSwizzler_isHidden_withAssertion)
                : #selector(UICollectionViewCell.swizzled_CollectionViewCellSwizzler_isHidden)
        )
    }
    
    private static func swizzle(_ originalSelector: Selector, _ swizzledSelector: Selector) {
        AssertingSwizzler().swizzle(UICollectionViewCell.self, originalSelector, swizzledSelector, .instanceMethod)
    }
    
    private init() {
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
    
    @objc fileprivate func swizzled_CollectionViewCellSwizzler_isHidden_withAssertion() -> Bool {
        return isHidden(
            originalImplementation: swizzled_CollectionViewCellSwizzler_isHidden_withAssertion,
            withAssertion: true
        )
    }
    
    @objc fileprivate func swizzled_CollectionViewCellSwizzler_isHidden() -> Bool {
        return isHidden(
            originalImplementation: swizzled_CollectionViewCellSwizzler_isHidden,
            withAssertion: false
        )
    }
    
    @nonobjc private func isHidden(
        originalImplementation: () -> Bool,
        withAssertion: Bool)
        -> Bool
    {
        guard let collectionViewCell = self as? UICollectionViewCell else {
            return originalImplementation()
        }
        
        if collectionViewCell.mb_isFakeCell() {
            if withAssertion {
                assertionFailure("isHidden should never be called for a fake cell")
            }
            
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
