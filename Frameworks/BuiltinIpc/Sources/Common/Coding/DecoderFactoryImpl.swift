#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC
#error("BuiltinIpc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC)
// The compilation is disabled
#else

public final class DecoderFactoryImpl: DecoderFactory {
    public let ipcClientHolder: IpcClientHolder
    public weak var encoderFactory: EncoderFactory?
    
    public init(ipcClientHolder: IpcClientHolder) {
        self.ipcClientHolder = ipcClientHolder
    }
    
    public func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: "+inf",
            negativeInfinity: "-inf",
            nan: "nan"
        )
        
        if  let ipcClientHolderKey = CodingUserInfoKey(rawValue: "ipcClientHolder") {
            decoder.userInfo[ipcClientHolderKey] = ipcClientHolder
        }
        if let encoderFactoryKey = CodingUserInfoKey(rawValue: "encoderFactory") {
            decoder.userInfo[encoderFactoryKey] = encoderFactory
        }
        if let decoderFactoryKey = CodingUserInfoKey(rawValue: "decoderFactory") {
            decoder.userInfo[decoderFactoryKey] = self
        }
        
        return decoder
    }
}

#endif
