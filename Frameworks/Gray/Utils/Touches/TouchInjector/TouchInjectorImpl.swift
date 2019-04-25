// Translated from Objective-C to Swift.
// Source: https://github.com/google/EarlGrey/blob/87ffa7ac2517cc8931e4e6ba11714961cbac6dd7/EarlGrey/Event/GREYTouchInjector.m
public final class TouchInjectorImpl: TouchInjector {
    private enum State {
        // Touch injection hasn't started yet.
        case pendingStart
        
        // Injection has started injecting touches
        case started
        
        // Touch injection has stopped. This state is reached when injector has
        // finished injecting all the queued touches.
        case stopped
    }
    
    private var enqueuedTouchInfoList = [TouchInfo]()
    private var state: State = .pendingStart
    private let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func enqueueForDelivery(touchInfo: TouchInfo) {
        assertIsOnMainThread()
        enqueuedTouchInfoList.append(touchInfo)
    }
    
    public func waitUntilAllTouchesAreDeliveredUsingInjector() {
        assertIsOnMainThread()
        
        // Start if necessary.
        switch state {
        case .pendingStart, .stopped:
            startInjecting()
        case .started:
            break
        }
        
        // Now wait for it to finish.
        // FIXME: Impl => Factory
        let runLoopSpinner = RunLoopSpinnerImpl(
            timeout: TimeInterval.greatestFiniteMagnitude,
            minRunLoopDrains: 0,
            maxSleepInterval: TimeInterval.greatestFiniteMagnitude,
            runLoopModesStackProvider: RunLoopModesStackProviderImpl()
        )
        
        _ = runLoopSpinner.spin(
            until: { [weak self] in
                guard let strongSelf = self else {
                    return true
                }
                
                return strongSelf.state == .stopped
            }
        )
    }
    
    private func startInjecting() {
        grayNotImplemented()
    }
}
