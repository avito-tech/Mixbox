#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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

#endif
