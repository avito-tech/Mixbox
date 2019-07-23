#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol FakeCellManagerForCollectionView: class {
    func createFakeCellInside(closure: () -> (UICollectionViewCell)) -> UICollectionViewCell
}

#endif
