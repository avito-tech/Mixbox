import MixboxTestsFoundation

public final class NonEscapingCallArgument {
    public let name: String?
    public let label: String?
    public let type: Any.Type
    public let value: NonEscapingCallArgumentValue
    
    public init(
        name: String?,
        label: String?,
        type: Any.Type,
        value: NonEscapingCallArgumentValue)
    {
        self.name = name
        self.label = label
        self.type = type
        self.value = value
    }
}
