import MixboxFoundation

extension UICollectionViewCell {
    // Note: getting value for a real cell can cause resetting property (to nil).
    // This is due to a decision that observing fakeness will cost us more than resetting properties while getting them.
    var mb_fakeCellInfo: FakeCellInfo? {
        get {
            resetFakenessOfCellIfNeeded()
            return objc_getAssociatedObject(self, &fakeCellInfo_associatedObjectKey) as? FakeCellInfo
        }
        set {
            objc_setAssociatedObject(
                self,
                &fakeCellInfo_associatedObjectKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
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
        mb_fakeCellInfo = nil
    }
}

private var fakeCellInfo_associatedObjectKey = "UICollectionViewCell_fakeCellInfo_928CE5104F8B"
