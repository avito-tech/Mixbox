import MixboxIpc

public final class PercentageOfVisibleAreaIpcMethod: IpcMethod {
    public typealias Arguments = String // view id
    public typealias ReturnValue = CGFloat?
    
    public init() {
    }
}
