#if MIXBOX_ENABLE_IN_APP_SERVICES
import Foundation
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
