#if MIXBOX_ENABLE_IN_APP_SERVICES
import Foundation

extension String {
    public var mb_deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    public func mb_appendingPathComponent(_ pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
    
    public var mb_lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    public var mb_resolvingSymlinksInPath: String {
        return (self as NSString).resolvingSymlinksInPath
    }
}

#endif
