public protocol IpcCallbackStorage: class {
    subscript(_ key: String) -> AsyncFunction<String, String?>? { get set }
}
