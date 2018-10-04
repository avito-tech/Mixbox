public final class ObjectiveCExceptionCatcher {
    public static func `catch`(
        try: () -> (),
        catch: (NSException) -> (),
        finally: () -> ())
    {
        ObjectiveCExceptionCatcherHelper_try(`try`, `catch`, finally)
    }
    
    private init() {
    }
}
