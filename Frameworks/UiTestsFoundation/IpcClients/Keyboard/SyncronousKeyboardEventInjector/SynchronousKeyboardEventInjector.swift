import MixboxIpcCommon

public protocol SynchronousKeyboardEventInjector {
    func inject(events: [KeyboardEvent]) throws
}
