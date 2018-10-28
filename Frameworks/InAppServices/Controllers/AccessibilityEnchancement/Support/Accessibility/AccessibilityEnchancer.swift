#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxTestability

final class AccessibilityEnchancer: NSObject {
    @objc static func takeOff(
        shouldAddAssertionForCallingIsHiddenOnFakeCell: Bool)
    {
        AccessibilityValueSwizzler.setUp()
        FakeCellsSwizzling.swizzle(
            // The assert is important, but it adds some side-effects that may break some tests,
            // in that case you can disable it and use it only in tests on this feature
            shouldAddAssertionForCallingIsHiddenOnFakeCell: shouldAddAssertionForCallingIsHiddenOnFakeCell
        )
        FakeCellManagerProvider.fakeCellManager = FakeCellManagerImpl.instance
    }
}

#endif
