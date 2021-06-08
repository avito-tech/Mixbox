#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol FakeCellManagerForCollectionView: AnyObject {
    func createFakeCellInside(closure: () -> (UICollectionViewCell)) -> UICollectionViewCell
}

#endif
