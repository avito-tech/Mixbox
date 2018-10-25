import MixboxTestability

public final class MixboxCollectionViewUpdatesActivityImpl: MixboxCollectionViewUpdatesActivity {
    private let collectionView: UICollectionView
    private var completeWasCalled = false
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    public func complete() {
        collectionView.completeCollectionViewUpdates()
        completeWasCalled = true
    }
    
    deinit {
        assert(completeWasCalled, "You have to call complete() on object returned from startCollectionViewUpdates")
    }
}
