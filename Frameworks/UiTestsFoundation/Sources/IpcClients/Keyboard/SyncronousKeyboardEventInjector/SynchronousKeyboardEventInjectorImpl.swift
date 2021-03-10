import MixboxIpcCommon
import MixboxIpc
import MixboxFoundation
import MixboxTestsFoundation

public final class SynchronousKeyboardEventInjectorImpl: SynchronousKeyboardEventInjector {
    public let keyboardEventInjector: KeyboardEventInjector
    public let runLoopSpinningWaiter: RunLoopSpinningWaiter
    
    public init(
        keyboardEventInjector: KeyboardEventInjector,
        runLoopSpinningWaiter: RunLoopSpinningWaiter)
    {
        self.keyboardEventInjector = keyboardEventInjector
        self.runLoopSpinningWaiter = runLoopSpinningWaiter
    }
    
    public func inject(events: [KeyboardEvent]) throws {
        // .some(.some(error)) - error in `KeyboardEventInjector`
        // .some(nil) - no error in `KeyboardEventInjector`
        // nil - couldn't get result within timeout
        var result: ErrorString??
        
        keyboardEventInjector.inject(events: events) { error in
            result = error
        }
        
        _ = runLoopSpinningWaiter.wait(timeout: 15, until: { result != nil })
        
        if let result = result {
            if let error = result {
                throw error
            } else {
                return
            }
        } else {
            throw ErrorString("Couldn't get result of `inject` within timeout. events: \(events)")
        }
    }
}
