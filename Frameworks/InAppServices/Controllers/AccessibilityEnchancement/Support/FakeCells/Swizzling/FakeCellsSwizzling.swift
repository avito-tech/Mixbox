#if MIXBOX_ENABLE_IN_APP_SERVICES

// Facade for swizzling for supporting FakeCells.
final class FakeCellsSwizzling {
    static func swizzle(shouldAddAssertionForCallingIsHiddenOnFakeCell: Bool) {
        CollectionViewSwizzler.swizzle()
        CollectionViewCellSwizzler.swizzle(
            shouldAddAssertionForCallingIsHiddenOnFakeCell: shouldAddAssertionForCallingIsHiddenOnFakeCell
        )
    }
}

#endif
