import MixboxUiTestsFoundation

public final class TouchInjectorFactoryImpl: TouchInjectorFactory {
    private let currentAbsoluteTimeProvider: CurrentAbsoluteTimeProvider
    private let runLoopSpinnerFactory: RunLoopSpinnerFactory
    
    public init(
        currentAbsoluteTimeProvider: CurrentAbsoluteTimeProvider,
        runLoopSpinnerFactory: RunLoopSpinnerFactory)
    {
        self.currentAbsoluteTimeProvider = currentAbsoluteTimeProvider
        self.runLoopSpinnerFactory = runLoopSpinnerFactory
    }
    
    public func touchInjector(
        window: UIWindow)
        -> TouchInjector
    {
        return TouchInjectorImpl(
            window: window,
            currentAbsoluteTimeProvider: currentAbsoluteTimeProvider,
            runLoopSpinnerFactory: runLoopSpinnerFactory
        )
    }
}
