import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxFoundation

public final class TouchInjectorFactoryImpl: TouchInjectorFactory {
    private let currentAbsoluteTimeProvider: CurrentAbsoluteTimeProvider
    private let runLoopSpinnerFactory: RunLoopSpinnerFactory
    private let multiTouchEventFactory: MultiTouchEventFactory
    
    public init(
        currentAbsoluteTimeProvider: CurrentAbsoluteTimeProvider,
        runLoopSpinnerFactory: RunLoopSpinnerFactory,
        multiTouchEventFactory: MultiTouchEventFactory)
    {
        self.currentAbsoluteTimeProvider = currentAbsoluteTimeProvider
        self.runLoopSpinnerFactory = runLoopSpinnerFactory
        self.multiTouchEventFactory = multiTouchEventFactory
    }
    
    public func touchInjector() -> TouchInjector {
        return TouchInjectorImpl(
            currentAbsoluteTimeProvider: currentAbsoluteTimeProvider,
            runLoopSpinnerFactory: runLoopSpinnerFactory,
            multiTouchEventFactory: multiTouchEventFactory
        )
    }
}
