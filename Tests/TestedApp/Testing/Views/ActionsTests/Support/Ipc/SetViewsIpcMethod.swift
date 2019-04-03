import MixboxIpc
import MixboxFoundation

public final class ActionsTestsViewModel: Codable {
    public let showInfo: Bool
    public let viewNames: [String]
    
    init(
        showInfo: Bool,
        viewNames: [String])
    {
        self.showInfo = showInfo
        self.viewNames = viewNames
    }
}

public final class SetViewsIpcMethod: IpcMethod {
    
    public typealias Arguments = ActionsTestsViewModel
    public typealias ReturnValue = ErrorString?
    
    public init() {
    }
}
