#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxTestability

public final class FakeCellManagerImpl: FakeCellManager {
    public init() {
    }
    
    // MARK: - FakeCellManager
    
    public func isFakeCell(forCell cell: UICollectionViewCell) -> Bool {
        return cell.mb_fakeCellInfo != nil || fakeCellIsBeingCreatedAtTheMoment.value == true
    }
    
    public func startCollectionViewUpdates(
        forCollectionView collectionView: UICollectionView)
        -> MixboxCollectionViewUpdatesActivity
    {
        collectionView.startCollectionViewUpdates()
        
        return MixboxCollectionViewUpdatesActivityImpl(
            collectionView: collectionView
        )
    }
    
    public func getConfigureAsFakeCell(forCell cell: UICollectionViewCell) -> (() -> ())? {
        return objc_getAssociatedObject(cell, &configureAsFakeCell_associatedObjectKey) as? (() -> ())
    }
    
    public func setConfigureAsFakeCell(configureAsFakeCell: (() -> ())?, forCell cell: UICollectionViewCell) {
        objc_setAssociatedObject(
            cell,
            &configureAsFakeCell_associatedObjectKey,
            configureAsFakeCell,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    public func createFakeCellInside(closure: () -> (UICollectionViewCell)) -> UICollectionViewCell {
        fakeCellIsBeingCreatedAtTheMoment.value = true
        let value = closure()
        fakeCellIsBeingCreatedAtTheMoment.value = false
        return value
    }
    
    private let fakeCellIsBeingCreatedAtTheMoment = ThreadLocalObject<Bool>(
        key: "897C6980D1EF_fakeCellIsBeingCreatedAtTheMoment",
        initialValue: false
    )
}

private var configureAsFakeCell_associatedObjectKey = "BEFC4E9F9161_configureAsFakeCell"

#endif
