#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol IpcCallbackStorage: class {
    subscript(_ key: String) -> AsyncFunction<String, String?>? { get set }
}

#endif
