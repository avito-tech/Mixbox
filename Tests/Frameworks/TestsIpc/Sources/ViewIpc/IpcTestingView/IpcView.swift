import UIKit

public final class IpcView: Codable {
    public let frame: CGRect
    public let accessibilityIdentifier: String?
    public let backgroundColor: IpcColor?
    public let alpha: CGFloat
    public let isHidden: Bool
    
    public init(
        frame: CGRect,
        accessibilityIdentifier: String? = nil,
        backgroundColor: IpcColor? = nil,
        alpha: CGFloat = 1,
        isHidden: Bool = false)
    {
        self.frame = frame
        self.accessibilityIdentifier = accessibilityIdentifier
        self.backgroundColor = backgroundColor
        self.alpha = alpha
        self.isHidden = isHidden
    }
}
