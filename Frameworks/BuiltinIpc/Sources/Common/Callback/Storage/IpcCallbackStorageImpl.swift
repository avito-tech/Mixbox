public final class IpcCallbackStorageImpl: IpcCallbackStorage {
    private var storage = [String: AsyncFunction<String, String?>]()
    
    public init() {
    }
    
    public subscript(_ key: String) -> AsyncFunction<String, String?>? {
        get { return storage[key] }
        set { storage[key] = newValue }
    }
}
