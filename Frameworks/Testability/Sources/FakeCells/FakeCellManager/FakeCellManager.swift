#if TEST

public protocol MixboxCollectionViewUpdatesActivity {
    func complete()
}

public protocol FakeCellManager {
    func isFakeCell(forCell: UICollectionViewCell) -> Bool
    func startCollectionViewUpdates(forCollectionView: UICollectionView) -> MixboxCollectionViewUpdatesActivity
    func getConfigureAsFakeCell(forCell: UICollectionViewCell) -> (() -> ())?
    func setConfigureAsFakeCell(configureAsFakeCell: (() -> ())?, forCell: UICollectionViewCell)
}

#endif
