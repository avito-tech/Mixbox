#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

import UIKit

public final class DisabledFakeCellManager: FakeCellManager {
    public func createFakeCellInside(closure: () -> (UICollectionViewCell)) -> UICollectionViewCell {
        return closure()
    }
    
    public func isFakeCell(forCell: UICollectionViewCell) -> Bool {
        return false
    }
    public func startCollectionViewUpdates(forCollectionView: UICollectionView) -> MixboxCollectionViewUpdatesActivity {
        
        return  DisabledMixboxCollectionViewUpdatesActivity()
    }
    public func getConfigureAsFakeCell(forCell: UICollectionViewCell) -> (() -> ())? {
        return nil
    }
    public func setConfigureAsFakeCell(configureAsFakeCell: (() -> ())?, forCell: UICollectionViewCell) {
    }
}

public final class DisabledMixboxCollectionViewUpdatesActivity: MixboxCollectionViewUpdatesActivity {
    public func complete() {
    }
}

#endif
