#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC
#error("BuiltinIpc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC)
// The compilation is disabled
#else

public final class EncoderFactoryImpl: EncoderFactory {
    public let ipcCallbackStorage: IpcCallbackStorage
    public weak var decoderFactory: DecoderFactory?
    
    public init(ipcCallbackStorage: IpcCallbackStorage) {
        self.ipcCallbackStorage = ipcCallbackStorage
    }
    
    public func encoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        
        encoder.nonConformingFloatEncodingStrategy = .convertToString(
            positiveInfinity: "+inf",
            negativeInfinity: "-inf",
            nan: "nan"
        )
        
        if let ipcCallbackStorageKey = CodingUserInfoKey(rawValue: "ipcCallbackStorage") {
            encoder.userInfo[ipcCallbackStorageKey] = ipcCallbackStorage
        }
        if let encoderFactoryKey = CodingUserInfoKey(rawValue: "encoderFactory") {
            encoder.userInfo[encoderFactoryKey] = self
        }
        if let decoderFactoryKey = CodingUserInfoKey(rawValue: "decoderFactory") {
            encoder.userInfo[decoderFactoryKey] = decoderFactory
        }
        
        return encoder
    }
}

#endif
