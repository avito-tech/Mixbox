public protocol TouchInjectorFactory: class {
    func touchInjector(
        window: UIWindow)
        -> TouchInjector
}
