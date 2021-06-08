#if MIXBOX_ENABLE_IN_APP_SERVICES

// Facade for swizzling for supporting FakeCells.
public protocol FakeCellsSwizzling: AnyObject {
    func swizzle()
}

#endif
