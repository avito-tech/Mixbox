import MixboxTestsFoundation

public final class RecordedCallArgument {
    public let name: String?
    public let type: Any.Type
    public let value: RecordedCallArgumentValue
    
    public init(
        name: String?,
        type: Any.Type,
        value: RecordedCallArgumentValue)
    {
        self.name = name
        self.type = type
        self.value = value
    }
}
