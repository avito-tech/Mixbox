#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxTestability
import MixboxFoundation
import Foundation
import UIKit
import MixboxInAppServices_objc

// TODO: Split. swiftlint:disable file_length
public final class CollectionViewSwizzlerImpl: CollectionViewSwizzler {
    private let assertingSwizzler: AssertingSwizzler
    private let onceToken = ThreadUnsafeOnceToken<Void>()
    
    public init(assertingSwizzler: AssertingSwizzler) {
        self.assertingSwizzler = assertingSwizzler
    }
    
    public func swizzle() {
        _ = onceToken.executeOnce {
            swizzleWhileBeingExecutedOnce()
        }
    }
    
    private func swizzleWhileBeingExecutedOnce() {
        swizzle(
            originalSelector: #selector(UICollectionView.reloadData),
            swizzledSelector: #selector(UICollectionView.swizzled_CollectionViewSwizzler_reloadData),
            shouldAssertIfMethodIsSwizzledOnlyOneTime: true
        )
        swizzle(
            originalSelector: #selector(UICollectionView.performBatchUpdates(_:completion:)),
            swizzledSelector: #selector(UICollectionView.swizzled_CollectionViewSwizzler_performBatchUpdates(_:completion:)),
            shouldAssertIfMethodIsSwizzledOnlyOneTime: true
        )
        // UIAccessibilityContainer:
        swizzle(
            originalSelector: #selector(UIView.accessibilityElementCount),
            swizzledSelector: #selector(UIView.swizzled_CollectionViewSwizzler_accessibilityElementCount),
            shouldAssertIfMethodIsSwizzledOnlyOneTime: false // Also swizzled for UICollectionViewCell
        )
        swizzle(
            originalSelector: #selector(UIView.accessibilityElement(at:)),
            swizzledSelector: #selector(UIView.swizzled_CollectionViewSwizzler_accessibilityElement(at:)),
            shouldAssertIfMethodIsSwizzledOnlyOneTime: false  // Also swizzled for UICollectionViewCell
        )
        swizzle(
            originalSelector: #selector(UIView.index(ofAccessibilityElement:)),
            swizzledSelector: #selector(UIView.swizzled_CollectionViewSwizzler_index(ofAccessibilityElement:)),
            shouldAssertIfMethodIsSwizzledOnlyOneTime: true
        )
        // Without swizzling that function below (with swizzling of functions of UIAccessibilityContainer only),
        // XCUI will somehow somethime strangely mix unnecessary cells into AX hierarchy. I didn't understand
        // how and why it does it. So, the default implementation of _accessibilityUserTestingChildren, which
        // calls UIAccessibilityContainer, returns an array with extra objects. That function is private,
        // the hack below was found after some reverse engineering.
        swizzle(
            originalSelector: Selector(("_accessibilityUserTestingChildren")),
            swizzledSelector: #selector(UIView.swizzled_CollectionViewSwizzler_accessibilityUserTestingChildren),
            shouldAssertIfMethodIsSwizzledOnlyOneTime: true
        )
    }
    
    private func swizzle(
        originalSelector: Selector,
        swizzledSelector: Selector,
        shouldAssertIfMethodIsSwizzledOnlyOneTime: Bool)
    {
        assertingSwizzler.swizzle(
            class: UICollectionView.self,
            originalSelector: originalSelector,
            swizzledSelector: swizzledSelector,
            methodType: .instanceMethod,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: shouldAssertIfMethodIsSwizzledOnlyOneTime
        )
    }
}

private var cellsState_associatedObjectKey = "UICollectionView_cellsState_297BF7468EC6"
private var cachedFakeCells_associatedObjectKey = "UICollectionView_cachedFakeCells_5F3FCE1CB0A0"

extension UICollectionView {
    @objc override open func testabilityValue_children() -> [UIView] {
        return collectionViewSwizzler_accessibilityUserTestingChildren().compactMap { $0 as? UIView }
    }
    
    private func changeStateInEverySuperview(cellsState: UICollectionView.CellsState) {
        var pointer: UIView? = self
        
        while let view = pointer {
            if let collectionView = view as? UICollectionView {
                collectionView.cellsState.value = cellsState
            }
            
            if let collectionView = (view as? UICollectionViewCell)?.mb_fakeCellInfo?.parentCollectionView {
                pointer = collectionView
            } else {
                pointer = superview
            }
        }
    }
    
    func startCollectionViewUpdates() {
        changeStateInEverySuperview(cellsState: .realCellsAreUpdating_fakeCellsCacheDoesNotExist)
    }
    
    func completeCollectionViewUpdates() {
        changeStateInEverySuperview(cellsState: .realCellsAreUpdated_fakeCellsCacheDoesNotExist)
    }
}

fileprivate extension UICollectionView {
    enum CellsState: String {
        // TODO: Make better structure of the state and put cache inside one of the cases to make state consistent.
        case realCellsAreUpdating_fakeCellsCacheDoesNotExist // to not do anything, because state is not consistent
        case realCellsAreUpdated_fakeCellsCacheDoesNotExist // to update cache
        case realCellsAreUpdated_fakeCellsCacheIsUpdating // basically to prevent stackoverflow
        case realCellsAreUpdated_fakeCellsCacheIsUpdated // to use cache
        case fakeCellsCacheCanNotBeObtained // to not use cache
        
        var needToUpdateCache: Bool {
            switch self {
            case .realCellsAreUpdated_fakeCellsCacheDoesNotExist:
                return true
            case .realCellsAreUpdating_fakeCellsCacheDoesNotExist,
                 .fakeCellsCacheCanNotBeObtained,
                 .realCellsAreUpdated_fakeCellsCacheIsUpdating,
                 .realCellsAreUpdated_fakeCellsCacheIsUpdated:
                return false
            }
        }
        
        var needToIgnoreCache: Bool {
            switch self {
            case .realCellsAreUpdating_fakeCellsCacheDoesNotExist,
                 .realCellsAreUpdated_fakeCellsCacheIsUpdating,
                 .fakeCellsCacheCanNotBeObtained:
                return true
            case .realCellsAreUpdated_fakeCellsCacheDoesNotExist,
                 .realCellsAreUpdated_fakeCellsCacheIsUpdated:
                return false
            }
        }
    }
    
    private var cachedFakeCells: AssociatedValue<[UICollectionViewCell]> {
        return AssociatedValue(container: self, key: #function, defaultValue: [])
    }
    
    private var cellsState: AssociatedValue<CellsState> {
        return AssociatedValue(
            container: self,
            key: #function,
            defaultValue: CellsState.realCellsAreUpdated_fakeCellsCacheDoesNotExist
        )
    }
    
    @objc func swizzled_CollectionViewSwizzler_reloadData() {
        cellsState.value = .realCellsAreUpdating_fakeCellsCacheDoesNotExist
        swizzled_CollectionViewSwizzler_reloadData()
        cellsState.value = .realCellsAreUpdated_fakeCellsCacheDoesNotExist
    }
    
    @objc func swizzled_CollectionViewSwizzler_performBatchUpdates(
        _ updates: (() -> ())?,
        completion: ((Bool) -> ())?)
    {
        cellsState.value = .realCellsAreUpdating_fakeCellsCacheDoesNotExist
        swizzled_CollectionViewSwizzler_performBatchUpdates(
            updates,
            completion: { [weak self] args in
                completion?(args)
                self?.cellsState.value = .realCellsAreUpdated_fakeCellsCacheDoesNotExist
            }
        )
    }
    
    // TODO: Cache subviews, this function should not be called for every accessibility element
    func getAccessibilityElements() -> [NSObject] {
        var collectionViewCells = [UIView]()
        var visibleCells = Set<UIView>()
        
        for fakeCell in cachedFakeCells.value {
            let cell: UIView
            
            assert(fakeCell.mb_fakeCellInfo != nil)
            
            if let indexPath = fakeCell.mb_fakeCellInfo?.indexPath,
                let visibleCell = cellForItem(at: indexPath)
            {
                cell = visibleCell
                visibleCells.insert(visibleCell)
            } else {
                cell = fakeCell
            }
            collectionViewCells.append(cell)
        }
        
        let allSubviewsThatAreNotCells = subviews.filter { view in
            // TODO: We can add a UICollectionViewCell with addSubview as well.
            // I know it is bad to add a cell via addSubview method instead of
            // via collection view interfaces, but is still possible...
            //
            // But we are filtering out all cells, because it is hard to distinguish between
            // cells that are used privatly by collection view for animations and cells that
            // app adds via addSubview.
            //
            // For example, there was different code, but we got tens of extra elements in hierarchy:
            //
            // !visibleCells.contains(view)
            
            !(view is UICollectionViewCell)
        }
        
        // TODO: Better mixing cells
        //
        // How it is working now:
        // fakeCell1 visibleCell1 visibleCell2 fakeCell2 fakeCell3 | subview1 subview1 subview3
        //
        // How it should working:
        // subview1 fakeCell1 visibleCell1 subview2 visibleCell2 fakeCell2 fakeCell3 subview3
        
        return (collectionViewCells + allSubviewsThatAreNotCells).map { cell in
            if let cell = cell as? UICollectionViewCell {
                if let indexPath = cell.mb_fakeCellInfo?.indexPath {
                    if let visibleCell = cellForItem(at: indexPath) {
                        return visibleCell
                    }
                }
            }
            
            return cell
        }
    }
    
    @nonobjc func collectionViewSwizzler_accessibilityElementCount() -> Int {
        if cellsState.value.needToIgnoreCache {
            return swizzled_CollectionViewSwizzler_accessibilityElementCount()
        }
        if cellsState.value.needToUpdateCache {
            updateAccessibilityElements()
        }
        return getAccessibilityElements().count
    }
    
    @nonobjc func collectionViewSwizzler_accessibilityElement(at index: Int) -> Any? {
        if cellsState.value.needToIgnoreCache {
            return swizzled_CollectionViewSwizzler_accessibilityElement(at: index)
        }
        if cellsState.value.needToUpdateCache {
            updateAccessibilityElements()
        }
        return getAccessibilityElements().mb_elementAtIndex(index)
    }
    
    @nonobjc func collectionViewSwizzler_index(ofAccessibilityElement element: Any) -> Int {
        if cellsState.value.needToIgnoreCache {
            return swizzled_CollectionViewSwizzler_index(ofAccessibilityElement: element)
        }
        if cellsState.value.needToUpdateCache {
            updateAccessibilityElements()
        }
        
        var index = (subviews as NSArray).index(of: element)
        if index == NSNotFound {
            index = (accessibilityElements as NSArray?)?.index(of: element) ?? NSNotFound
        }
        return index
    }
    
    @nonobjc func collectionViewSwizzler_accessibilityUserTestingChildren() -> NSArray {
        if cellsState.value.needToIgnoreCache {
            return swizzled_CollectionViewSwizzler_accessibilityUserTestingChildren()
        }
        if cellsState.value.needToUpdateCache {
            updateAccessibilityElements()
        }
        
        return getAccessibilityElements() as NSArray
    }
    
    // TODO: Split. swiftlint:disable:next function_body_length
    @nonobjc private func updateAccessibilityElements() {
        assert(cellsState.value == .realCellsAreUpdated_fakeCellsCacheDoesNotExist)
        cellsState.value = .realCellsAreUpdated_fakeCellsCacheIsUpdating
        
        // Without calling `reuseCell` dequeueing of cells will lead to leaks, new cells will
        // appear hidden in real view hierarchy.
        for fakeCell in self.cachedFakeCells.value {
            ObjectiveCExceptionCatcher.catch(
                try: {
                    fakeCell.mb_fakeCellInfo = nil
                    _reuse(fakeCell)
                },
                catch: { _ in }
            )
        }
        
        self.cachedFakeCells.value = []
        
        var cachedFakeCells = [UICollectionViewCell]()
        
        ObjectiveCExceptionCatcher.catch(
            try: {
                if let dataSource = dataSource {
                    for sectionId in 0..<numberOfSections {
                        for itemId in 0..<numberOfItems(inSection: sectionId) {
                            let indexPath = IndexPath(row: itemId, section: sectionId)
                            
                            let fakeCell = FakeCellManagerProvider.fakeCellManager.createFakeCellInside {
                                // Usage of native function to create cell for a specific index path.
                                // It has some problems that were solved via swizzling of UICollectionViewCell.
                                dataSource.collectionView(
                                    self,
                                    cellForItemAt: indexPath
                                )
                            }
                            
                            // `collectionView(_:cellForItemAt:)` can add subview to collection view.
                            // I think there is no logic for that, and I think Apple did it because they thought
                            // that `collectionView(_:cellForItemAt:)` should always be followed by
                            // adding cell as subview. Note that this behavior is not constant, in fact
                            // usually cell is not added to collection view.
                            fakeCell.removeFromSuperview()
                            fakeCell._setHidden(forReuse: false)
                            
                            assert(!fakeCell.isNotFakeCellDueToPresenceInViewHierarchy())
                            
                            fakeCell.mb_fakeCellInfo = FakeCellInfo(
                                indexPath: indexPath,
                                parentCollectionView: self
                            )
                            fakeCell.mb_configureAsFakeCell?()
                            
                            // It wouldn't be called without a parent.
                            // But it is needed to set a frame. Elements with zero frame are not shown in AX hierarchy.
                            fakeCell.setNeedsLayout()
                            fakeCell.layoutIfNeeded()
                            
                            cachedFakeCells.append(fakeCell)
                        }
                    }
                }
                
                self.cachedFakeCells.value = cachedFakeCells
                cellsState.value = .realCellsAreUpdated_fakeCellsCacheIsUpdated
            },
            catch: { _ in
                for fakeCell in self.cachedFakeCells.value {
                    ObjectiveCExceptionCatcher.catch(
                        try: {
                            fakeCell.mb_fakeCellInfo = nil
                            _reuse(fakeCell)
                        },
                        catch: { _ in
                            // TODO: Notify via assertion failure.
                        }
                    )
                }
                
                self.cachedFakeCells.value = []
                cellsState.value = .fakeCellsCacheCanNotBeObtained
            }
        )
    }
}

// Note that we use extension on UIView. Because we don't want to know for sure what class implements
// a certain method if the method is defined in UIView.
//
// E.g. `_accessibilityUserTestingChildren` method is implemented in UIView and trying to implicitly cast (access)
// `self` as UICollectionView will lead to a crash. Also it is something that may change. We want to be
// tolerant to where the method is actually implemented.
private extension UIView {
    @objc func swizzled_CollectionViewSwizzler_accessibilityElementCount() -> Int {
        guard let collectionView = self as? UICollectionView else {
            return swizzled_CollectionViewSwizzler_accessibilityElementCount()
        }
        
        return ObjectiveCExceptionCatcher.catch(
            try: {
                collectionView.collectionViewSwizzler_accessibilityElementCount()
            },
            catch: { _ in
                swizzled_CollectionViewSwizzler_accessibilityElementCount()
            }
        )
    }
    
    @objc func swizzled_CollectionViewSwizzler_accessibilityElement(at index: Int) -> Any? {
        guard let collectionView = self as? UICollectionView else {
            return swizzled_CollectionViewSwizzler_accessibilityElement(at: index)
        }
        
        return ObjectiveCExceptionCatcher.catch(
            try: {
                collectionView.collectionViewSwizzler_accessibilityElement(at: index)
            },
            catch: { _ in
                swizzled_CollectionViewSwizzler_accessibilityElement(at: index)
            }
        )
    }
    
    @objc func swizzled_CollectionViewSwizzler_index(ofAccessibilityElement element: Any) -> Int {
        guard let collectionView = self as? UICollectionView else {
            return swizzled_CollectionViewSwizzler_index(ofAccessibilityElement: element)
        }
        
        return ObjectiveCExceptionCatcher.catch(
            try: {
                collectionView.collectionViewSwizzler_index(ofAccessibilityElement: element)
            },
            catch: { _ in
                swizzled_CollectionViewSwizzler_index(ofAccessibilityElement: element)
            }
        )
    }
    
    @objc func swizzled_CollectionViewSwizzler_accessibilityUserTestingChildren() -> NSArray {
        guard let collectionView = self as? UICollectionView else {
            return swizzled_CollectionViewSwizzler_accessibilityUserTestingChildren()
        }
        
        return ObjectiveCExceptionCatcher.catch(
            try: {
                collectionView.collectionViewSwizzler_accessibilityUserTestingChildren()
            },
            catch: { _ in
                swizzled_CollectionViewSwizzler_accessibilityUserTestingChildren()
            }
        )
    }
}

#endif
