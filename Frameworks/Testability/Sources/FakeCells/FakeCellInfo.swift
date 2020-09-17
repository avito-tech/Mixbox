#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public final class FakeCellInfo {
    public let indexPath: IndexPath
    public var parentCollectionView: UICollectionView? {
        return parentCollectionViewBox.value
    }
    
    private let parentCollectionViewBox: WeakBox<UICollectionView>
    
    public init(
        indexPath: IndexPath,
        parentCollectionView: UICollectionView)
    {
        self.indexPath = indexPath
        self.parentCollectionViewBox = WeakBox<UICollectionView>(parentCollectionView)
    }
}

#endif
