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
