import MixboxFoundation

public final class MockedInstanceInfo {
    public let type: BaseMock.Type
    public let mirror: Mirror
    public let fileLineWhereInitialized: FileLine
    
    public init(
        type: BaseMock.Type,
        mirror: Mirror,
        fileLineWhereInitialized: FileLine)
    {
        self.type = type
        self.mirror = mirror
        self.fileLineWhereInitialized = fileLineWhereInitialized
    }
}
