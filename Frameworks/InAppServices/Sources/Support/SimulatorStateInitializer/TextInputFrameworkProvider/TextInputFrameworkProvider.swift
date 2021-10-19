#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol TextInputFrameworkProvider {
    func withLoadedFramework(
        body: (TextInputFramework) throws -> ()
    ) throws
}

#endif
