#if MIXBOX_ENABLE_IN_APP_SERVICES

// We have to use a singleton, because... you know... we swizzle things.
public final class FakeCellManagerProvider {
    public static var fakeCellManager: FakeCellManager = DisabledFakeCellManager()
}

#endif
