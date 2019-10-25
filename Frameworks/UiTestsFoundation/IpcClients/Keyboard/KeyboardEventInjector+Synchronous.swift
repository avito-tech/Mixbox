import MixboxIpcCommon
import MixboxIpc
import MixboxFoundation

extension KeyboardEventInjector {
    public func inject(events: [KeyboardEvent]) throws {
        // .some(.some(error)) - error in `KeyboardEventInjector`
        // .some(nil) - no error in `KeyboardEventInjector`
        // nil - couldn't get result within timeout
        var result: ErrorString??
        
        inject(events: events) { error in
            result = error
        }
        
        IpcSynchronization.waitWhile { result == nil }
        
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
