import MixboxTestability
import MixboxFoundation

// TODO: Fix linter rule, it should ignore missing colons inside #selector
// swiftlint:disable missing_spaces_after_colon

final class CollectionViewSwizzler {
    static func swizzle() {
        swizzle(
            #selector(UICollectionView.reloadData),
            #selector(UICollectionView.swizzled_CollectionViewSwizzler_reloadData)
        )
        swizzle(
            #selector(UICollectionView.performBatchUpdates(_:completion:)),
            #selector(UICollectionView.swizzled_CollectionViewSwizzler_performBatchUpdates(_:completion:))
        )
        // UIAccessibilityContainer:
        swizzle(
            #selector(UIView.accessibilityElementCount),
            #selector(UIView.swizzled_CollectionViewSwizzler_accessibilityElementCount)
        )
        swizzle(
            #selector(UIView.accessibilityElement(at:)),
            #selector(UIView.swizzled_CollectionViewSwizzler_accessibilityElement(at:))
        )
        swizzle(
            #selector(UIView.index(ofAccessibilityElement:)),
            #selector(UIView.swizzled_CollectionViewSwizzler_index(ofAccessibilityElement:))
        )
        // Without swizzling that function below (with swizzling of functions of UIAccessibilityContainer only),
        // XCUI will somehow somethime strangely mix unnecessary cells into AX hierarchy. I didn't understand
        // how and why it does it. So, the default implementation of _accessibilityUserTestingChildren, which
        // calls UIAccessibilityContainer, returns an array with extra objects. That function is private,
        // the hack below was found after some reverse engineering.
        swizzle(
            Selector(("_accessibilityUserTestingChildren")),
            #selector(UIView.swizzled_CollectionViewSwizzler_accessibilityUserTestingChildren)
        )
    }
    
    private static func swizzle(_ originalSelector: Selector, _ swizzledSelector: Selector) {
        AssertingSwizzler().swizzle(UICollectionView.self, originalSelector, swizzledSelector, .instanceMethod)
    }
    
    private init() {
    }
}

private var cellsState_associatedObjectKey = "UICollectionView_cellsState_297BF7468EC6"
private var cachedFakeCells_associatedObjectKey = "UICollectionView_cachedFakeCells_5F3FCE1CB0A0"

extension UICollectionView {
    @objc override open func testabilityValue_children() -> [UIView] {
        return collectionViewSwizzler_accessibilityUserTestingChildren().compactMap { $0 as? UIView }
    }
}

fileprivate extension UICollectionView {
    private enum CellsState: String {
        // TODO: Make better structure of the state and put cache inside one of the cases to make state consistent.
        case realCellsAreUpdating_fakeCellsCacheDoesNotExist // to not do anything, because state is not consistent
        case realCellsAreUpdated_fakeCellsCacheDoesNotExist // to update cache
        case realCellsAreUpdated_fakeCellsCacheIsUpdating // basically to prevent stackoverflow
        case realCellsAreUpdated_fakeCellsCacheIsUpdated // to use cache
        
        var needToUpdateCache: Bool {
            switch self {
            case .realCellsAreUpdated_fakeCellsCacheDoesNotExist:
                return true
            case .realCellsAreUpdating_fakeCellsCacheDoesNotExist,
                 .realCellsAreUpdated_fakeCellsCacheIsUpdating,
                 .realCellsAreUpdated_fakeCellsCacheIsUpdated:
                return false
            }
        }
        
        var needToIgnoreCache: Bool {
            switch self {
            case .realCellsAreUpdating_fakeCellsCacheDoesNotExist:
                return true
            case .realCellsAreUpdated_fakeCellsCacheDoesNotExist,
                 .realCellsAreUpdated_fakeCellsCacheIsUpdating,
                 .realCellsAreUpdated_fakeCellsCacheIsUpdated:
                return false
            }
        }
    }
    
    private var cachedFakeCells: [UICollectionViewCell] {
        get {
            guard let value = objc_getAssociatedObject(self, &cachedFakeCells_associatedObjectKey) as? [UICollectionViewCell] else {
                let initialValue = [UICollectionViewCell]()
                objc_setAssociatedObject(
                    self,
                    &cachedFakeCells_associatedObjectKey,
                    initialValue,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
                return initialValue
            }
            
            return value
        }
        set {
            objc_setAssociatedObject(
                self,
                &cachedFakeCells_associatedObjectKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    private var cellsState: CellsState {
        get {
            let initialValue = CellsState.realCellsAreUpdated_fakeCellsCacheDoesNotExist
            guard let value = objc_getAssociatedObject(self, &cellsState_associatedObjectKey) as? String else {
                objc_setAssociatedObject(
                    self,
                    &cellsState_associatedObjectKey,
                    initialValue.rawValue,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
                return initialValue
            }
            
            return CellsState(rawValue: value) ?? initialValue
        }
        set {
            objc_setAssociatedObject(
                self,
                &cellsState_associatedObjectKey,
                newValue.rawValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    @objc func swizzled_CollectionViewSwizzler_reloadData() {
        cellsState = .realCellsAreUpdating_fakeCellsCacheDoesNotExist
        swizzled_CollectionViewSwizzler_reloadData()
        cellsState = .realCellsAreUpdated_fakeCellsCacheDoesNotExist
    }
    
    @objc func swizzled_CollectionViewSwizzler_performBatchUpdates(
        _ updates: (() -> ())?,
        completion: ((Bool) -> ())?)
    {
        cellsState = .realCellsAreUpdating_fakeCellsCacheDoesNotExist
        swizzled_CollectionViewSwizzler_performBatchUpdates(
            updates,
            completion: { [weak self] args in
                completion?(args)
                self?.cellsState = .realCellsAreUpdated_fakeCellsCacheDoesNotExist
            }
        )
    }
    
    // TODO: Cache subviews, this function should not be called for every accessibility element
    func getAccessibilityElements() -> [NSObject] {
        var collectionViewCells = [UIView]()
        var visibleCells = Set<UIView>()
        
        for fakeCell in cachedFakeCells {
            let cell: UIView
            
            assert(fakeCell.indexPath != nil)
            
            if let indexPath = fakeCell.indexPath, let visibleCell = cellForItem(at: indexPath) {
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
        
        return collectionViewCells + allSubviewsThatAreNotCells
    }
    
    @nonobjc func collectionViewSwizzler_accessibilityElementCount() -> Int {
        if cellsState.needToIgnoreCache {
            return swizzled_CollectionViewSwizzler_accessibilityElementCount()
        }
        if cellsState.needToUpdateCache {
            updateAccessibilityElements()
        }
        return getAccessibilityElements().count
    }
    
    @nonobjc func collectionViewSwizzler_accessibilityElement(at index: Int) -> Any? {
        if cellsState.needToIgnoreCache {
            return swizzled_CollectionViewSwizzler_accessibilityElement(at: index)
        }
        if cellsState.needToUpdateCache {
            updateAccessibilityElements()
        }
        return accessibilityElementFromCache(index: index)
    }
    
    @nonobjc func collectionViewSwizzler_index(ofAccessibilityElement element: Any) -> Int {
        if cellsState.needToIgnoreCache {
            return swizzled_CollectionViewSwizzler_index(ofAccessibilityElement: element)
        }
        if cellsState.needToUpdateCache {
            updateAccessibilityElements()
        }
        
        var index = (subviews as NSArray).index(of: element)
        if index == NSNotFound {
            index = (accessibilityElements as NSArray?)?.index(of: element) ?? NSNotFound
        }
        return index
    }
    
    @nonobjc func collectionViewSwizzler_accessibilityUserTestingChildren() -> NSArray {
        if cellsState.needToIgnoreCache {
            return swizzled_CollectionViewSwizzler_accessibilityUserTestingChildren()
        }
        if cellsState.needToUpdateCache {
            updateAccessibilityElements()
        }
        
        let accessibilityElements = (0..<accessibilityElementCount()).compactMap { index in
            accessibilityElementFromCache(index: index)
        }
        
        return accessibilityElements as NSArray
    }
    
    @nonobjc private func accessibilityElementFromCache(index: Int) -> Any? {
        guard let element = getAccessibilityElements().mb_elementAtIndex(index) else {
            return nil
        }
        
        if let cell = element as? UICollectionViewCell {
            if let indexPath = cell.indexPath {
                if let visibleCell = cellForItem(at: indexPath) {
                    return visibleCell
                }
            }
        }
        
        return element
    }
    
    @nonobjc private func updateAccessibilityElements() {
        assert(cellsState == .realCellsAreUpdated_fakeCellsCacheDoesNotExist)
        cellsState = .realCellsAreUpdated_fakeCellsCacheIsUpdating
        
        // Without calling `reuseCell` dequeueing of cells will lead to leaks, new cells will
        // appear hidden in real view hierarchy.
        for fakeCell in self.cachedFakeCells {
            _reuse(fakeCell)
        }
        
        var cachedFakeCells = [UICollectionViewCell]()
        
        if let dataSource = dataSource {
            for sectionId in 0..<numberOfSections {
                for itemId in 0..<numberOfItems(inSection: sectionId) {
                    let indexPath = IndexPath(row: itemId, section: sectionId)
                    
                    // Usage of native function to create cell for a specific index path.
                    // It has some problems that were solved via swizzling of UICollectionViewCell.
                    let fakeCell = dataSource.collectionView(
                        self,
                        cellForItemAt: indexPath
                    )
                    
                    // `collectionView(_:cellForItemAt:)` can add subview to collection view.
                    // I think there is no logic for that, and I think Apple did it because they thought
                    // that `collectionView(_:cellForItemAt:)` should always be followed by
                    // adding cell as subview. Note that this behavior is not constant, in fact
                    // usually cell is not added to collection view.
                    fakeCell.removeFromSuperview()
                    fakeCell._setHidden(forReuse: false)
                    
                    assert(!fakeCell.isNotFakeCellDueToPresenceInViewHierarchy())
                    
                    fakeCell.indexPath = indexPath
                    fakeCell.parentCollectionView = self
                    
                    #if TEST
                    fakeCell.configureAsFakeCell?()
                    #endif
                    
                    // It wouldn't be called without a parent.
                    // But it is needed to set a frame. Elements with zero frame are not shown in AX hierarchy.
                    fakeCell.setNeedsLayout()
                    fakeCell.layoutIfNeeded()
                    
                    cachedFakeCells.append(fakeCell)
                }
            }
        }
        
        self.cachedFakeCells = cachedFakeCells
        
        cellsState = .realCellsAreUpdated_fakeCellsCacheIsUpdated
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
        
        return collectionView.collectionViewSwizzler_accessibilityElementCount()
    }
    
    @objc func swizzled_CollectionViewSwizzler_accessibilityElement(at index: Int) -> Any? {
        guard let collectionView = self as? UICollectionView else {
            return swizzled_CollectionViewSwizzler_accessibilityElement(at: index)
        }
        
        return collectionView.collectionViewSwizzler_accessibilityElement(at: index)
    }
    
    @objc func swizzled_CollectionViewSwizzler_index(ofAccessibilityElement element: Any) -> Int {
        guard let collectionView = self as? UICollectionView else {
            return swizzled_CollectionViewSwizzler_index(ofAccessibilityElement: element)
        }
        
        return collectionView.collectionViewSwizzler_index(ofAccessibilityElement: element)
    }
    
    @objc func swizzled_CollectionViewSwizzler_accessibilityUserTestingChildren() -> NSArray {
        guard let collectionView = self as? UICollectionView else {
            return swizzled_CollectionViewSwizzler_accessibilityUserTestingChildren()
        }
        
        return collectionView.collectionViewSwizzler_accessibilityUserTestingChildren()
    }
}
