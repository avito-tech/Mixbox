#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol MixboxCollectionViewUpdatesActivity: class {
    func complete()
}

public protocol FakeCellManager: class {
    func isFakeCell(forCell: UICollectionViewCell) -> Bool
    func startCollectionViewUpdates(forCollectionView: UICollectionView) -> MixboxCollectionViewUpdatesActivity
    func getConfigureAsFakeCell(forCell: UICollectionViewCell) -> (() -> ())?
    func setConfigureAsFakeCell(configureAsFakeCell: (() -> ())?, forCell: UICollectionViewCell)
}

#endif
