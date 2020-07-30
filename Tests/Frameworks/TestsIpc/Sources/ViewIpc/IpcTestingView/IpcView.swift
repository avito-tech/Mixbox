public final class IpcView: Codable {
    public let frame: CGRect
    public let accessibilityIdentifier: String?
    public let backgroundColor: IpcColor
    
    public init(
        frame: CGRect,
        accessibilityIdentifier: String?,
        backgroundColor: IpcColor)
    {
        self.frame = frame
        self.accessibilityIdentifier = accessibilityIdentifier
        self.backgroundColor = backgroundColor
    }
}
