#if TEST

// We have to use a singleton, because... you know... we swizzle things.
public final class FakeCellManagerProvider {
    public static var fakeCellManager: FakeCellManager = DisabledFakeCellManager()
}

#endif
