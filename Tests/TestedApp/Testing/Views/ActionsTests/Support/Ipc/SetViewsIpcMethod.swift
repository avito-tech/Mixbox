import MixboxIpc
import MixboxFoundation

public final class ActionsTestsViewModel: Codable {
    public let showInfo: Bool
    public let viewNames: [String]
    public let alpha: CGFloat
    public let isHidden: Bool
    public let overlapping: CGFloat
    
    public init(
        showInfo: Bool,
        viewNames: [String],
        alpha: CGFloat,
        isHidden: Bool,
        overlapping: CGFloat)
    {
        self.showInfo = showInfo
        self.viewNames = viewNames
        self.alpha = alpha
        self.isHidden = isHidden
        self.overlapping = overlapping
    }
}

public final class SetViewsIpcMethod: IpcMethod {
    
    public typealias Arguments = ActionsTestsViewModel
    public typealias ReturnValue = ErrorString?
    
    public init() {
    }
}
