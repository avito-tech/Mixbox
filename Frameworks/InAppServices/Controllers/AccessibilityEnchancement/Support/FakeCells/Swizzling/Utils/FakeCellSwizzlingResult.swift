// Used to assert if there were no conflicts in swizzling
// And if swizzling was successful
enum FakeCellSwizzlingResult {
    case swizzledOriginalMethod(Method)
    case failedToGetOriginalMethod(NSObject.Type, Selector)
    case failedToGetSwizzledMethod(NSObject.Type, Selector)
    
    var originalMethod: Method? {
        switch self {
        case .swizzledOriginalMethod(let method):
            return method
        default:
            return nil
        }
    }
}
