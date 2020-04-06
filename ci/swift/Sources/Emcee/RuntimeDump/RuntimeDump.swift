import TestDiscovery

public final class RuntimeDump {
    public let discoveredTestEntries: [DiscoveredTestEntry]
    
    public init(discoveredTestEntries: [DiscoveredTestEntry]) {
        self.discoveredTestEntries = discoveredTestEntries
    }
}
