public protocol TouchInjectorFactory {
    func touchInjector(
        window: UIWindow)
        -> TouchInjector
}
