public final class SimctlListResult: Codable {
    public typealias PairId = String
    
    public let devices: [DeviceTypeIdentifier: [Device]]
    public let devicetypes: [DeviceType]
    public let runtimes: [Runtime]
    public let pairs: [PairId: Pair]
    
    public init(
        devices: [RuntimeIdentifier: [Device]],
        devicetypes: [DeviceType],
        runtimes: [Runtime],
        pairs: [PairId: Pair])
    {
        self.devices = devices
        self.devicetypes = devicetypes
        self.runtimes = runtimes
        self.pairs = pairs
    }
}
