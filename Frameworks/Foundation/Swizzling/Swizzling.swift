// Example:
//
// var swizzlings: [Swizzling] = [nsObjectSwizzling, nsProxySwizzling]
// swizzlings.forEach { $0.swizzle() }
//
public protocol Swizzling: class {
    func swizzle()
}
