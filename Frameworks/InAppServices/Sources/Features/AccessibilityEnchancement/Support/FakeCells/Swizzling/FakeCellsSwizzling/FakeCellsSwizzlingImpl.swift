#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class FakeCellsSwizzlingImpl: FakeCellsSwizzling {
    private let collectionViewCellSwizzler: CollectionViewCellSwizzler
    private let collectionViewSwizzler: CollectionViewSwizzler
    
    public init(
        collectionViewCellSwizzler: CollectionViewCellSwizzler,
        collectionViewSwizzler: CollectionViewSwizzler)
    {
        self.collectionViewCellSwizzler = collectionViewCellSwizzler
        self.collectionViewSwizzler = collectionViewSwizzler
    }
    
    public func swizzle() {
        collectionViewCellSwizzler.swizzle()
        collectionViewSwizzler.swizzle()
    }
}

#endif
