import Foundation

#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

import UIKit
#if SWIFT_PACKAGE
import MixboxTestabilityObjc
#endif


// Extension that allows you to tune Fake Cells for your specific implementation of collection view.
//
// How-to:
// - configure cell only in `mb_configureAsFakeCell` if `cell.mb_isFakeCell() == true`
// - avoid making any changes outside of cell. For example, do not trigger services
//   in configuration of cell if `cell.mb_isFakeCell() == true`
//
// Is it necessary?
// It may be not necessary, but I suggest you to set everything up as described here.
//
// The reasons why you may use this are:
// 1. to remove any side effects on a real views (makes sense if they are possible).
// 2. to set up configuration closure for a fake cell (makes sense if cell is not configured right in `cellForItemAt`).
//
// Example (reason #1):
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//      ...
//      #if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
//      #error("Testability is marked as both enabled and disabled, choose one of the flags")
//      #elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
//      // The compilation is disabled
//      #else
//
//      // To not update fake cell instead of a real one:
//      if !cell.mb_isFakeCell() {
//          someService.someCallback = { cell.someUpdateFunction() }
//      }
//
//      #endif
//      ...
//  }
//
// Example (reason #2):
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//      ...
//      #if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
//      #error("Testability is marked as both enabled and disabled, choose one of the flags")
//      #elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
//      // The compilation is disabled
//      #else
//
//      if cell.mb_isFakeCell() {
//          cell.mb_configureAsFakeCell = { [weak cell] in cell?.someUpdateFunction() }
//      }
//
//      #endif
//      ...
//  }
//
//  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//      ...
//      cell?.someUpdateFunction()
//      ...
//  }
//
// Note: instead of those scary #if-clauses you may want to use something simple like `#if TEST` in your project (you have to define it in compilation settings, though).
//

extension UICollectionViewCell {
    // TODO: Remove @objc.
    @objc public func mb_isFakeCell() -> Bool {
        return FakeCellManagerProvider.fakeCellManager.isFakeCell(forCell: self)
    }
    
    public var mb_configureAsFakeCell: (() -> ())? {
        get {
            return FakeCellManagerProvider.fakeCellManager.getConfigureAsFakeCell(forCell: self)
        }
        set {
            FakeCellManagerProvider.fakeCellManager.setConfigureAsFakeCell(
                configureAsFakeCell: newValue,
                forCell: self
            )
        }
    }
}

extension UICollectionView {
    // For cases when automatic invalidation of cache does not work.
    // PLEASE report such cases to https://github.com/avito-tech/Mixbox/issues
    // You must call complete() on MixboxCollectionViewUpdatesActivity when updating is finished.
    public func mb_startCollectionViewUpdates() -> MixboxCollectionViewUpdatesActivity {
        return FakeCellManagerProvider.fakeCellManager.startCollectionViewUpdates(forCollectionView: self)
    }
}

#endif
