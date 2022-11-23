#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
