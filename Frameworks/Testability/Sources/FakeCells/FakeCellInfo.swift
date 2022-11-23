#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

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
