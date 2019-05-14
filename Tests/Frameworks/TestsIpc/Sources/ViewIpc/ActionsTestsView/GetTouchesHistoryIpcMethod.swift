import MixboxIpc
import MixboxFoundation

public final class GetUiEventHistoryIpcMethod: IpcMethod {
    public typealias Arguments = Date // since when
    public typealias ReturnValue = UiEventHistory
    
    public init() {
    }
}
