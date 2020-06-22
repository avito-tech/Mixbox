#if MIXBOX_ENABLE_IN_APP_SERVICES
import Foundation
import UIKit

public protocol FakeCellManagerForCollectionView: class {
    func createFakeCellInside(closure: () -> (UICollectionViewCell)) -> UICollectionViewCell
}

#endif
