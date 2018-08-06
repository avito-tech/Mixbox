import MixboxFoundation

extension UICollectionViewCell {
    // Note: getting value for a real cell can cause resetting property (to nil).
    // This is due to a decision that observing fakeness will cost us more than resetting properties while getting them.
    @objc var indexPath: IndexPath? {
        get {
            resetFakenessOfCellIfNeeded()
            return objc_getAssociatedObject(self, &indexPath_associatedObjectKey) as? IndexPath
        }
        set {
            objc_setAssociatedObject(
                self,
                &indexPath_associatedObjectKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    @objc var parentCollectionView: UICollectionView? {
        get {
            resetFakenessOfCellIfNeeded()
            let box = objc_getAssociatedObject(self, &parentCollectionView_associatedObjectKey) as? WeakBox<UICollectionView>
            return box?.value
        }
        set {
            objc_setAssociatedObject(
                self,
                &parentCollectionView_associatedObjectKey,
                newValue.flatMap { WeakBox<UICollectionView>($0) },
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    func isFakeCell() -> Bool {
        return parentCollectionView != nil || indexPath != nil
    }
    
    @objc override func isHidden_consideringFakenessOfCell() -> Bool {
        if isFakeCell() {
            return false
        } else {
            return isHidden
        }
    }
    
    private func resetFakenessOfCellIfNeeded() {
        if isNotFakeCellDueToPresenceInViewHierarchy() {
            resetFakenessOfCell()
        }
    }
    
    func isNotFakeCellDueToPresenceInViewHierarchy() -> Bool {
        return superview != nil && _isHiddenForReuse() == false
    }
    
    private func resetFakenessOfCell() {
        parentCollectionView = nil
        indexPath = nil
    }
}

@objc extension UIView {
    @objc func isHidden_consideringFakenessOfCell() -> Bool {
        if let cell = self as? UICollectionViewCell {
            return cell.isHidden_consideringFakenessOfCell()
        } else {
            return isHidden
        }
    }
}

private var indexPath_associatedObjectKey = "UICollectionViewCell_indexPath_928CE5104F8B"
private var parentCollectionView_associatedObjectKey = "UICollectionViewCell_parentCollectionView_6ED6E865057C"
