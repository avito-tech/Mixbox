import RuntimeDump

public final class RuntimeDump {
    public let runtimeTestEntries: [RuntimeTestEntry]
    
    public init(runtimeTestEntries: [RuntimeTestEntry]) {
        self.runtimeTestEntries = runtimeTestEntries
    }
}
