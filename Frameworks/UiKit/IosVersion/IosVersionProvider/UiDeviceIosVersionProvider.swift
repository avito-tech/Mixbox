#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class UiDeviceIosVersionProvider: IosVersionProvider {
    private let uiDevice: UIDevice
    
    public init(uiDevice: UIDevice) {
        self.uiDevice = uiDevice
    }
    
    public func iosVersion() -> IosVersion {
        let versionComponents = uiDevice
            .systemVersion
            .components(separatedBy: ".")
            .compactMap { $0.mb_toInt() }
        
        return IosVersion(
            versionComponents: versionComponents
        )
    }
}

#endif
